import "jsr:@supabase/functions-js/edge-runtime.d.ts";

interface TranslationRequest {
  text: string;
  sourceLanguage: string;
  targetLanguages: string[];
}

interface TranslationResponse {
  [language: string]: {
    text: string;
  };
}

Deno.serve(async (req: Request) => {
  // Обработка CORS preflight запросов
  if (req.method === "OPTIONS") {
    return new Response("ok", {
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST",
        "Access-Control-Allow-Headers": "Content-Type",
      },
    });
  }

  try {
    const body: TranslationRequest = await req.json();

    // Валидация входных данных
    if (!body.text || body.text.trim() === "") {
      return new Response(
        JSON.stringify({
          success: false,
          error: "Empty text",
          translations: {},
        }),
        {
          status: 400,
          headers: { "Content-Type": "application/json" },
        }
      );
    }

    if (
      !body.sourceLanguage ||
      !body.targetLanguages ||
      body.targetLanguages.length === 0
    ) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "Invalid language parameters",
          translations: {},
        }),
        {
          status: 400,
          headers: { "Content-Type": "application/json" },
        }
      );
    }

    console.log(
      `Translating "${body.text}" from ${body.sourceLanguage} to [${body.targetLanguages.join(", ")}]`
    );

    // Создаем промпт для Gemini
    const translationPrompt = buildTranslationPrompt(
      body.text,
      body.sourceLanguage,
      body.targetLanguages
    );

    // Получаем переводы от Gemini
    const translations = await translateWithGemini(translationPrompt);

    return new Response(
      JSON.stringify({
        success: true,
        error: null,
        translations: translations,
      }),
      {
        status: 200,
        headers: { "Content-Type": "application/json" },
      }
    );
  } catch (error) {
    const errorMessage =
      error instanceof Error ? error.message : "Unknown error";
    console.error("Translation error:", errorMessage);

    return new Response(
      JSON.stringify({
        success: false,
        error: errorMessage,
        translations: {},
      }),
      {
        status: 500,
        headers: { "Content-Type": "application/json" },
      }
    );
  }
});

/// Строит промпт для Gemini для перевода текста
function buildTranslationPrompt(
  text: string,
  sourceLanguage: string,
  targetLanguages: string[]
): string {
  const languageNames: { [key: string]: string } = {
    en: "English",
    ru: "Russian",
    uk: "Ukrainian",
    es: "Spanish",
    de: "German",
    fr: "French",
    it: "Italian",
  };

  const targetLangsFormatted = targetLanguages
    .map((lang) => `${languageNames[lang] || lang} (${lang})`)
    .join(", ");

  return `You are a professional translator for a cosmetics app poll system. Translate the following poll option text into the specified languages.

Source text: "${text}"
Source language: ${languageNames[sourceLanguage] || sourceLanguage} (${sourceLanguage})
Target languages: ${targetLangsFormatted}

Requirements:
1. Translations should be natural and concise
2. Keep the meaning exactly the same
3. Match the tone of the original
4. Response must be valid JSON format only

Return ONLY a valid JSON object (no markdown, no explanations) with this exact structure:
{
  "en": { "text": "translation in English" },
  "ru": { "text": "translation in Russian" },
  "uk": { "text": "translation in Ukrainian" },
  "es": { "text": "translation in Spanish" },
  "de": { "text": "translation in German" },
  "fr": { "text": "translation in French" },
  "it": { "text": "translation in Italian" }
}

Only include the target languages specified above. Do not include the source language in the response.`;
}

/// Отправляет запрос к Gemini API для перевода
async function translateWithGemini(
  prompt: string
): Promise<TranslationResponse> {
  const apiKey = Deno.env.get("GEMINI_API_KEY");

  if (!apiKey) {
    throw new Error("GEMINI_API_KEY environment variable not set");
  }

  const url =
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=" +
    apiKey;

  const requestBody = {
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
      temperature: 0.3, // Lower temperature for more consistent translations
      topK: 40,
      topP: 0.95,
      maxOutputTokens: 1024,
    },
  };

  const response = await fetch(url, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(requestBody),
  });

  if (!response.ok) {
    const errorData = await response.text();
    console.error(`Gemini API error: ${response.status} - ${errorData}`);
    throw new Error(`Gemini API error: ${response.status}`);
  }

  const responseData = await response.json();

  // Извлекаем текст ответа из Gemini
  const responseText =
    responseData?.candidates?.[0]?.content?.parts?.[0]?.text;

  if (!responseText) {
    throw new Error("No response text from Gemini");
  }

  console.log("Gemini response:", responseText);

  // Парсим JSON из ответа
  let translations: TranslationResponse;

  try {
    // Пытаемся найти JSON в ответе
    const jsonMatch = responseText.match(/\{[\s\S]*\}/);
    if (!jsonMatch) {
      throw new Error("No JSON found in response");
    }

    translations = JSON.parse(jsonMatch[0]);
  } catch (parseError) {
    console.error("Failed to parse Gemini response as JSON:", parseError);
    throw new Error("Failed to parse translation response");
  }

  return translations;
}
