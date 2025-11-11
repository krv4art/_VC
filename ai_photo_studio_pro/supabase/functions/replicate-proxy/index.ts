// Supabase Edge Function for proxying Replicate API calls
// This keeps the API key secure on the server side

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

const REPLICATE_API_KEY = Deno.env.get('REPLICATE_API_KEY')
const REPLICATE_API_URL = 'https://api.replicate.com/v1'

interface GenerateRequest {
  image: string // base64 encoded image
  prompt: string
  quality?: string
  model?: string
}

interface CheckStatusRequest {
  action: 'check_status'
  job_id: string
}

interface CancelRequest {
  action: 'cancel'
  job_id: string
}

type RequestBody = GenerateRequest | CheckStatusRequest | CancelRequest

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
    // Check API key
    if (!REPLICATE_API_KEY) {
      throw new Error('REPLICATE_API_KEY not configured')
    }

    const body: RequestBody = await req.json()

    // Check if this is a status check or cancel request
    if ('action' in body) {
      if (body.action === 'check_status') {
        return await checkJobStatus(body.job_id, corsHeaders)
      } else if (body.action === 'cancel') {
        return await cancelJob(body.job_id, corsHeaders)
      }
    }

    // Otherwise, it's a generation request
    const generateRequest = body as GenerateRequest
    return await createPrediction(generateRequest, corsHeaders)

  } catch (error) {
    console.error('Error:', error)
    return new Response(
      JSON.stringify({ error: error.message }),
      {
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      }
    )
  }
})

async function createPrediction(request: GenerateRequest, corsHeaders: Record<string, string>) {
  const model = request.model || 'black-forest-labs/flux-1-schnell'

  // Build Replicate prediction request
  const replicateRequest = {
    version: getModelVersion(model),
    input: {
      image: `data:image/jpeg;base64,${request.image}`,
      prompt: request.prompt,
      num_outputs: 1,
      aspect_ratio: "1:1", // Square for headshots
      output_format: "jpg",
      output_quality: getQualityValue(request.quality || 'medium'),
    }
  }

  // Call Replicate API
  const response = await fetch(`${REPLICATE_API_URL}/predictions`, {
    method: 'POST',
    headers: {
      'Authorization': `Token ${REPLICATE_API_KEY}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(replicateRequest),
  })

  if (!response.ok) {
    const error = await response.text()
    throw new Error(`Replicate API error: ${error}`)
  }

  const data = await response.json()

  return new Response(
    JSON.stringify(data),
    {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 201,
    }
  )
}

async function checkJobStatus(jobId: string, corsHeaders: Record<string, string>) {
  const response = await fetch(`${REPLICATE_API_URL}/predictions/${jobId}`, {
    method: 'GET',
    headers: {
      'Authorization': `Token ${REPLICATE_API_KEY}`,
      'Content-Type': 'application/json',
    },
  })

  if (!response.ok) {
    const error = await response.text()
    throw new Error(`Replicate API error: ${error}`)
  }

  const data = await response.json()

  return new Response(
    JSON.stringify(data),
    {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 200,
    }
  )
}

async function cancelJob(jobId: string, corsHeaders: Record<string, string>) {
  const response = await fetch(`${REPLICATE_API_URL}/predictions/${jobId}/cancel`, {
    method: 'POST',
    headers: {
      'Authorization': `Token ${REPLICATE_API_KEY}`,
      'Content-Type': 'application/json',
    },
  })

  if (!response.ok) {
    const error = await response.text()
    throw new Error(`Replicate API error: ${error}`)
  }

  const data = await response.json()

  return new Response(
    JSON.stringify(data),
    {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 200,
    }
  )
}

function getModelVersion(model: string): string {
  // Map model names to their versions
  // These should be updated with latest versions from Replicate
  const versions: Record<string, string> = {
    'black-forest-labs/flux-1-schnell': 'latest', // Fast generation
    'black-forest-labs/flux-pro': 'latest', // High quality
    'black-forest-labs/flux-dev': 'latest', // Development version
  }

  return versions[model] || 'latest'
}

function getQualityValue(quality: string): number {
  const qualityMap: Record<string, number> = {
    'low': 70,
    'medium': 85,
    'high': 95,
  }

  return qualityMap[quality] || 85
}
