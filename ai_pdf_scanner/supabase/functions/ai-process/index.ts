// AI Processing Edge Function
// Secure proxy to Google Gemini API for AI-powered document analysis
// Deployed to Supabase Edge Functions

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'

const GEMINI_API_KEY = Deno.env.get('GEMINI_API_KEY')
const GEMINI_API_URL = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent'

interface AnalyzeImageRequest {
  type: 'analyze_image'
  image: string // base64 encoded
  prompt: string
  temperature?: number
}

interface TranslateRequest {
  type: 'translate'
  text: string
  target_language: string
}

type RequestBody = AnalyzeImageRequest | TranslateRequest

serve(async (req) => {
  // CORS headers
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  }

  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Parse request body
    const body: RequestBody = await req.json()

    // Validate API key
    if (!GEMINI_API_KEY) {
      throw new Error('GEMINI_API_KEY not configured')
    }

    // Process based on type
    let result: any

    if (body.type === 'analyze_image') {
      result = await analyzeImage(body)
    } else if (body.type === 'translate') {
      result = await translateText(body)
    } else {
      throw new Error('Invalid request type')
    }

    return new Response(
      JSON.stringify(result),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200,
      }
    )
  } catch (error) {
    console.error('Error processing AI request:', error)
    return new Response(
      JSON.stringify({ error: error.message }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 500,
      }
    )
  }
})

/**
 * Analyze image using Gemini Vision
 */
async function analyzeImage(request: AnalyzeImageRequest) {
  const { image, prompt, temperature = 0.4 } = request

  // Prepare Gemini API request
  const geminiRequest = {
    contents: [
      {
        parts: [
          {
            text: prompt,
          },
          {
            inline_data: {
              mime_type: 'image/jpeg',
              data: image,
            },
          },
        ],
      },
    ],
    generationConfig: {
      temperature,
      maxOutputTokens: 2048,
    },
  }

  // Call Gemini API
  const response = await fetch(`${GEMINI_API_URL}?key=${GEMINI_API_KEY}`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(geminiRequest),
  })

  if (!response.ok) {
    const error = await response.text()
    throw new Error(`Gemini API error: ${error}`)
  }

  const data = await response.json()

  // Extract response text
  const text = data.candidates?.[0]?.content?.parts?.[0]?.text || ''

  // Try to parse as JSON if response looks like JSON
  let result: any
  if (text.trim().startsWith('{') || text.trim().startsWith('[')) {
    try {
      result = JSON.parse(text)
    } catch {
      result = { text }
    }
  } else {
    result = { text }
  }

  return result
}

/**
 * Translate text using Gemini
 */
async function translateText(request: TranslateRequest) {
  const { text, target_language } = request

  const prompt = `Translate the following text to ${target_language}.
Return only the translated text without any additional commentary.

Text to translate:
${text}`

  const geminiRequest = {
    contents: [
      {
        parts: [
          {
            text: prompt,
          },
        ],
      },
    ],
    generationConfig: {
      temperature: 0.3,
      maxOutputTokens: 2048,
    },
  }

  const response = await fetch(`${GEMINI_API_URL}?key=${GEMINI_API_KEY}`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(geminiRequest),
  })

  if (!response.ok) {
    const error = await response.text()
    throw new Error(`Gemini API error: ${error}`)
  }

  const data = await response.json()
  const translatedText = data.candidates?.[0]?.content?.parts?.[0]?.text || text

  return { translated_text: translatedText.trim() }
}
