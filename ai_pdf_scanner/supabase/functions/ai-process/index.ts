// AI Processing Edge Function
// Proxies requests to Gemini API with secure API key handling

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

const GEMINI_API_KEY = Deno.env.get('GEMINI_API_KEY')
const GEMINI_API_URL = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent'

interface AIRequest {
  type: 'analyze_image' | 'translate'
  image?: string // base64
  prompt?: string
  text?: string
  target_language?: string
  temperature?: number
}

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
    // Parse request
    const body: AIRequest = await req.json()

    // Validate API key
    if (!GEMINI_API_KEY) {
      throw new Error('GEMINI_API_KEY not configured')
    }

    // Route to appropriate handler
    let result: any

    switch (body.type) {
      case 'analyze_image':
        result = await analyzeImage(body.image!, body.prompt!, body.temperature || 0.4)
        break

      case 'translate':
        result = await translateText(body.text!, body.target_language!)
        break

      default:
        throw new Error(`Unknown request type: ${body.type}`)
    }

    return new Response(
      JSON.stringify(result),
      {
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      }
    )

  } catch (error) {
    console.error('AI processing error:', error)

    return new Response(
      JSON.stringify({
        error: error.message || 'Internal server error'
      }),
      {
        status: 500,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json'
        }
      }
    )
  }
})

/**
 * Analyze image with Gemini Vision
 */
async function analyzeImage(
  base64Image: string,
  prompt: string,
  temperature: number
): Promise<any> {
  const requestBody = {
    contents: [
      {
        parts: [
          {
            text: prompt
          },
          {
            inline_data: {
              mime_type: "image/jpeg",
              data: base64Image
            }
          }
        ]
      }
    ],
    generationConfig: {
      temperature: temperature,
      topK: 40,
      topP: 0.95,
      maxOutputTokens: 8192,
    }
  }

  const response = await fetch(`${GEMINI_API_URL}?key=${GEMINI_API_KEY}`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(requestBody)
  })

  if (!response.ok) {
    const error = await response.text()
    throw new Error(`Gemini API error: ${error}`)
  }

  const data = await response.json()

  // Extract text from response
  const text = data.candidates?.[0]?.content?.parts?.[0]?.text || ''

  // Try to parse as JSON if it looks like JSON
  let parsedResult
  try {
    if (text.trim().startsWith('{') || text.trim().startsWith('[')) {
      parsedResult = JSON.parse(text)
    } else {
      parsedResult = { text }
    }
  } catch {
    parsedResult = { text }
  }

  return parsedResult
}

/**
 * Translate text with Gemini
 */
async function translateText(
  text: string,
  targetLanguage: string
): Promise<any> {
  const prompt = `Translate the following text to ${targetLanguage}. Return only the translated text, nothing else:\n\n${text}`

  const requestBody = {
    contents: [
      {
        parts: [
          {
            text: prompt
          }
        ]
      }
    ],
    generationConfig: {
      temperature: 0.3,
      topK: 40,
      topP: 0.95,
      maxOutputTokens: 8192,
    }
  }

  const response = await fetch(`${GEMINI_API_URL}?key=${GEMINI_API_KEY}`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(requestBody)
  })

  if (!response.ok) {
    const error = await response.text()
    throw new Error(`Gemini API error: ${error}`)
  }

  const data = await response.json()
  const translatedText = data.candidates?.[0]?.content?.parts?.[0]?.text || text

  return {
    translated_text: translatedText.trim()
  }
}
