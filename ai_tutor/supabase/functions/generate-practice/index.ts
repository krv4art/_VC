import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

interface RequestBody {
  subject: string
  topic: string
  difficulty: number
  interests: string[]
  cultural_theme: string
  learning_style: string
  count?: number
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const {
      subject,
      topic,
      difficulty,
      interests,
      cultural_theme,
      learning_style,
      count = 5
    } = await req.json() as RequestBody

    const openaiApiKey = Deno.env.get('OPENAI_API_KEY')
    if (!openaiApiKey) {
      throw new Error('OpenAI API key not configured')
    }

    // Build personalized prompt
    const prompt = `Generate ${count} practice problems for ${subject} on the topic of ${topic}.

PERSONALIZATION:
- Student interests: ${interests.join(', ')}
- Cultural theme: ${cultural_theme}
- Learning style: ${learning_style}
- Difficulty level: ${difficulty}/10

REQUIREMENTS:
1. Use examples and contexts from the student's interests (${interests.join(', ')})
2. Make problems engaging and relatable
3. Match the difficulty level (${difficulty}/10)
4. Adapt language to the cultural theme (${cultural_theme})
5. Consider the learning style (${learning_style})

FORMAT:
For each problem, provide:
{
  "problem": "The problem statement with personalized context",
  "difficulty": ${difficulty},
  "hints": ["Hint 1", "Hint 2", "Hint 3"],
  "solution_steps": ["Step 1", "Step 2", "..."],
  "answer": "The final answer",
  "concepts": ["Concept 1", "Concept 2"]
}

Return ONLY a JSON array of ${count} problems. No additional text.`

    const openaiResponse = await fetch('https://api.openai.com/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${openaiApiKey}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        model: 'gpt-4-turbo-preview',
        messages: [
          {
            role: 'system',
            content: 'You are an expert educational content creator. Generate engaging, personalized practice problems. Return ONLY valid JSON.'
          },
          {
            role: 'user',
            content: prompt
          }
        ],
        temperature: 0.8,
        max_tokens: 2000,
        response_format: { type: 'json_object' },
      }),
    })

    if (!openaiResponse.ok) {
      throw new Error(`OpenAI API error: ${openaiResponse.status}`)
    }

    const data = await openaiResponse.json()
    const responseText = data.choices[0]?.message?.content || '{}'

    let problems
    try {
      const parsed = JSON.parse(responseText)
      problems = parsed.problems || []
    } catch {
      problems = []
    }

    // Store generated problems (optional)
    try {
      const supabaseUrl = Deno.env.get('SUPABASE_URL')!
      const supabaseKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
      const supabase = createClient(supabaseUrl, supabaseKey)

      for (const problem of problems) {
        await supabase.from('practice_problems').insert({
          subject,
          topic,
          difficulty,
          problem: problem.problem,
          hints: problem.hints,
          solution_steps: problem.solution_steps,
          answer: problem.answer,
          concepts: problem.concepts,
          interests,
          cultural_theme,
          created_at: new Date().toISOString(),
        })
      }
    } catch (logError) {
      console.error('Failed to store problems:', logError)
    }

    return new Response(
      JSON.stringify({ problems }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200,
      }
    )
  } catch (error) {
    console.error('Error in generate-practice function:', error)
    return new Response(
      JSON.stringify({
        error: error.message,
        problems: []
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 500,
      }
    )
  }
})
