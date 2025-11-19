-- Migration: Create Enhanced AI Features Schema
-- Description: Creates tables for batch generation, enhanced photos, and AI processing history
-- Date: 2025-01-19

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- BATCH GENERATION TABLES
-- ============================================================================

-- Batch Generation Jobs Table
-- Tracks bulk photo generation jobs with progress and status
CREATE TABLE IF NOT EXISTS public.batch_generation_jobs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,

    -- Job Configuration
    style_id TEXT NOT NULL,
    custom_prompt TEXT,
    number_of_variations INTEGER NOT NULL DEFAULT 1 CHECK (number_of_variations >= 1 AND number_of_variations <= 20),
    high_resolution BOOLEAN DEFAULT FALSE,

    -- Optional Enhancement Settings
    enable_retouch BOOLEAN DEFAULT FALSE,
    retouch_preset TEXT, -- 'natural', 'professional', 'glamour', or NULL for custom
    retouch_settings JSONB, -- Custom retouch settings if retouch_preset is NULL

    enable_background_change BOOLEAN DEFAULT FALSE,
    background_settings JSONB, -- Background configuration

    -- Job Status
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'failed', 'cancelled')),
    total_photos INTEGER NOT NULL DEFAULT 0,
    completed_photos INTEGER NOT NULL DEFAULT 0,
    failed_photos INTEGER NOT NULL DEFAULT 0,

    -- Error Tracking
    error_message TEXT,

    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    started_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    -- Metadata
    metadata JSONB DEFAULT '{}'::jsonb
);

-- Batch Generation Items Table
-- Individual photos in a batch job
CREATE TABLE IF NOT EXISTS public.batch_generation_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    job_id UUID NOT NULL REFERENCES public.batch_generation_jobs(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,

    -- Source Photo
    source_image_path TEXT NOT NULL,
    source_image_url TEXT,

    -- Generated Photos
    variation_number INTEGER NOT NULL DEFAULT 1,
    generated_image_path TEXT,
    generated_image_url TEXT,

    -- Processing Status
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'failed')),
    error_message TEXT,

    -- Processing Steps
    headshot_generated BOOLEAN DEFAULT FALSE,
    retouch_applied BOOLEAN DEFAULT FALSE,
    background_changed BOOLEAN DEFAULT FALSE,
    upscaled BOOLEAN DEFAULT FALSE,

    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    started_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,

    -- Metadata
    metadata JSONB DEFAULT '{}'::jsonb,

    UNIQUE(job_id, source_image_path, variation_number)
);

-- ============================================================================
-- ENHANCED PHOTOS TABLE
-- ============================================================================

-- Enhanced Photos Table
-- Tracks all AI-enhanced photos with their processing history
CREATE TABLE IF NOT EXISTS public.enhanced_photos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,

    -- Original Photo
    original_image_path TEXT NOT NULL,
    original_image_url TEXT,

    -- Enhanced Photo
    enhanced_image_path TEXT NOT NULL,
    enhanced_image_url TEXT,

    -- Enhancement Type
    enhancement_type TEXT NOT NULL CHECK (enhancement_type IN (
        'retouch',
        'background_removal',
        'background_replacement',
        'outfit_change',
        'aspect_ratio_expansion',
        'upscaling',
        'combined' -- Multiple enhancements applied
    )),

    -- Enhancement Settings (stored as JSONB for flexibility)
    enhancement_settings JSONB NOT NULL,

    -- Processing Info
    processing_time_seconds NUMERIC(10, 2),
    model_used TEXT, -- e.g., 'FLUX.1', 'Real-ESRGAN', 'Remove.bg'

    -- Quality Metrics
    original_resolution TEXT, -- e.g., '512x512'
    enhanced_resolution TEXT, -- e.g., '2048x2048'
    file_size_bytes BIGINT,

    -- User Engagement
    is_favorite BOOLEAN DEFAULT FALSE,
    downloaded BOOLEAN DEFAULT FALSE,
    shared BOOLEAN DEFAULT FALSE,

    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    -- Metadata
    metadata JSONB DEFAULT '{}'::jsonb
);

-- ============================================================================
-- AI PROCESSING HISTORY TABLES
-- ============================================================================

-- Retouch History Table
CREATE TABLE IF NOT EXISTS public.retouch_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    enhanced_photo_id UUID REFERENCES public.enhanced_photos(id) ON DELETE CASCADE,

    -- Settings Used
    preset_used TEXT, -- 'natural', 'professional', 'glamour', or NULL for custom
    remove_blemishes BOOLEAN DEFAULT FALSE,
    smooth_skin BOOLEAN DEFAULT FALSE,
    enhance_lighting BOOLEAN DEFAULT FALSE,
    color_correction BOOLEAN DEFAULT FALSE,
    remove_shine BOOLEAN DEFAULT FALSE,
    enhance_eyes BOOLEAN DEFAULT FALSE,
    whiten_teeth BOOLEAN DEFAULT FALSE,
    smoothness_level NUMERIC(3, 2) DEFAULT 0.5 CHECK (smoothness_level >= 0 AND smoothness_level <= 1),
    lighting_intensity NUMERIC(3, 2) DEFAULT 0.5 CHECK (lighting_intensity >= 0 AND lighting_intensity <= 1),

    -- Processing
    processing_time_seconds NUMERIC(10, 2),

    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Background Changes History Table
CREATE TABLE IF NOT EXISTS public.background_changes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    enhanced_photo_id UUID REFERENCES public.enhanced_photos(id) ON DELETE CASCADE,

    -- Background Type
    background_type TEXT NOT NULL CHECK (background_type IN ('remove', 'replace', 'blur')),

    -- Background Settings
    background_style TEXT, -- 'office', 'studio', 'outdoor', etc.
    custom_background_url TEXT,
    background_color TEXT, -- Hex color code
    blur_amount NUMERIC(3, 2) DEFAULT 0 CHECK (blur_amount >= 0 AND blur_amount <= 1),

    -- Processing
    processing_time_seconds NUMERIC(10, 2),
    removal_service TEXT, -- 'remove.bg', 'replicate', etc.

    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Outfit Changes History Table
CREATE TABLE IF NOT EXISTS public.outfit_changes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    enhanced_photo_id UUID REFERENCES public.enhanced_photos(id) ON DELETE CASCADE,

    -- Outfit Settings
    outfit_type TEXT, -- 'business_suit_male', 'medical_scrubs', etc.
    custom_prompt TEXT,

    -- Processing
    processing_time_seconds NUMERIC(10, 2),
    model_used TEXT,

    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Image Expansion History Table
CREATE TABLE IF NOT EXISTS public.image_expansions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    enhanced_photo_id UUID REFERENCES public.enhanced_photos(id) ON DELETE CASCADE,

    -- Expansion Settings
    original_aspect_ratio TEXT NOT NULL, -- e.g., '1:1', '4:5'
    target_aspect_ratio TEXT NOT NULL, -- e.g., '9:16', '16:9'
    expansion_direction TEXT NOT NULL CHECK (expansion_direction IN ('all', 'horizontal', 'vertical')),

    -- Processing
    processing_time_seconds NUMERIC(10, 2),
    model_used TEXT,

    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Image Upscaling History Table
CREATE TABLE IF NOT EXISTS public.image_upscaling (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    enhanced_photo_id UUID REFERENCES public.enhanced_photos(id) ON DELETE CASCADE,

    -- Upscaling Settings
    scale_factor INTEGER NOT NULL CHECK (scale_factor IN (2, 4)),
    quality_mode TEXT NOT NULL CHECK (quality_mode IN ('standard', 'high', 'ultra')),
    original_resolution TEXT NOT NULL,
    final_resolution TEXT NOT NULL,

    -- Processing
    processing_time_seconds NUMERIC(10, 2),
    model_used TEXT DEFAULT 'Real-ESRGAN',

    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================================
-- INDEXES FOR PERFORMANCE
-- ============================================================================

-- Batch Generation Jobs Indexes
CREATE INDEX idx_batch_jobs_user_id ON public.batch_generation_jobs(user_id);
CREATE INDEX idx_batch_jobs_status ON public.batch_generation_jobs(status);
CREATE INDEX idx_batch_jobs_created_at ON public.batch_generation_jobs(created_at DESC);
CREATE INDEX idx_batch_jobs_user_status ON public.batch_generation_jobs(user_id, status);

-- Batch Generation Items Indexes
CREATE INDEX idx_batch_items_job_id ON public.batch_generation_items(job_id);
CREATE INDEX idx_batch_items_user_id ON public.batch_generation_items(user_id);
CREATE INDEX idx_batch_items_status ON public.batch_generation_items(status);

-- Enhanced Photos Indexes
CREATE INDEX idx_enhanced_photos_user_id ON public.enhanced_photos(user_id);
CREATE INDEX idx_enhanced_photos_type ON public.enhanced_photos(enhancement_type);
CREATE INDEX idx_enhanced_photos_created_at ON public.enhanced_photos(created_at DESC);
CREATE INDEX idx_enhanced_photos_favorite ON public.enhanced_photos(user_id, is_favorite) WHERE is_favorite = TRUE;

-- History Tables Indexes
CREATE INDEX idx_retouch_history_user_id ON public.retouch_history(user_id);
CREATE INDEX idx_retouch_history_photo_id ON public.retouch_history(enhanced_photo_id);
CREATE INDEX idx_background_changes_user_id ON public.background_changes(user_id);
CREATE INDEX idx_outfit_changes_user_id ON public.outfit_changes(user_id);
CREATE INDEX idx_image_expansions_user_id ON public.image_expansions(user_id);
CREATE INDEX idx_image_upscaling_user_id ON public.image_upscaling(user_id);

-- ============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================================================

-- Enable RLS on all tables
ALTER TABLE public.batch_generation_jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.batch_generation_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.enhanced_photos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.retouch_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.background_changes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.outfit_changes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.image_expansions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.image_upscaling ENABLE ROW LEVEL SECURITY;

-- Batch Generation Jobs Policies
CREATE POLICY "Users can view own batch jobs"
    ON public.batch_generation_jobs FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can create own batch jobs"
    ON public.batch_generation_jobs FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own batch jobs"
    ON public.batch_generation_jobs FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own batch jobs"
    ON public.batch_generation_jobs FOR DELETE
    USING (auth.uid() = user_id);

-- Batch Generation Items Policies
CREATE POLICY "Users can view own batch items"
    ON public.batch_generation_items FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can create own batch items"
    ON public.batch_generation_items FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own batch items"
    ON public.batch_generation_items FOR UPDATE
    USING (auth.uid() = user_id);

-- Enhanced Photos Policies
CREATE POLICY "Users can view own enhanced photos"
    ON public.enhanced_photos FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can create own enhanced photos"
    ON public.enhanced_photos FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own enhanced photos"
    ON public.enhanced_photos FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own enhanced photos"
    ON public.enhanced_photos FOR DELETE
    USING (auth.uid() = user_id);

-- History Tables Policies (same pattern for all)
CREATE POLICY "Users can view own retouch history"
    ON public.retouch_history FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can create own retouch history"
    ON public.retouch_history FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can view own background changes"
    ON public.background_changes FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can create own background changes"
    ON public.background_changes FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can view own outfit changes"
    ON public.outfit_changes FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can create own outfit changes"
    ON public.outfit_changes FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can view own image expansions"
    ON public.image_expansions FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can create own image expansions"
    ON public.image_expansions FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can view own image upscaling"
    ON public.image_upscaling FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can create own image upscaling"
    ON public.image_upscaling FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- ============================================================================
-- TRIGGERS FOR AUTOMATIC UPDATES
-- ============================================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for batch_generation_jobs
CREATE TRIGGER update_batch_jobs_updated_at
    BEFORE UPDATE ON public.batch_generation_jobs
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger for enhanced_photos
CREATE TRIGGER update_enhanced_photos_updated_at
    BEFORE UPDATE ON public.enhanced_photos
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Function to update batch job progress
CREATE OR REPLACE FUNCTION update_batch_job_progress()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE public.batch_generation_jobs
    SET
        completed_photos = (
            SELECT COUNT(*)
            FROM public.batch_generation_items
            WHERE job_id = NEW.job_id
            AND status = 'completed'
        ),
        failed_photos = (
            SELECT COUNT(*)
            FROM public.batch_generation_items
            WHERE job_id = NEW.job_id
            AND status = 'failed'
        ),
        status = CASE
            WHEN (
                SELECT COUNT(*)
                FROM public.batch_generation_items
                WHERE job_id = NEW.job_id
                AND status IN ('completed', 'failed')
            ) = (
                SELECT total_photos
                FROM public.batch_generation_jobs
                WHERE id = NEW.job_id
            ) THEN 'completed'
            ELSE 'processing'
        END
    WHERE id = NEW.job_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to update batch job when items change
CREATE TRIGGER update_batch_job_on_item_change
    AFTER INSERT OR UPDATE ON public.batch_generation_items
    FOR EACH ROW
    EXECUTE FUNCTION update_batch_job_progress();

-- ============================================================================
-- STORAGE BUCKET POLICIES (for Supabase Storage)
-- ============================================================================

-- Note: Run these commands in the Supabase dashboard or via API
-- CREATE BUCKET IF NOT EXISTS 'enhanced-photos';
-- CREATE BUCKET IF NOT EXISTS 'batch-generations';

-- Storage policies are managed through Supabase dashboard
-- Ensure authenticated users can:
-- - Upload to their own user folder
-- - Read their own uploaded files
-- - Delete their own files

-- ============================================================================
-- COMMENTS FOR DOCUMENTATION
-- ============================================================================

COMMENT ON TABLE public.batch_generation_jobs IS 'Tracks bulk photo generation jobs for enterprise users';
COMMENT ON TABLE public.batch_generation_items IS 'Individual photos in a batch generation job';
COMMENT ON TABLE public.enhanced_photos IS 'All AI-enhanced photos with processing history';
COMMENT ON TABLE public.retouch_history IS 'History of AI retouch operations';
COMMENT ON TABLE public.background_changes IS 'History of background removal/replacement operations';
COMMENT ON TABLE public.outfit_changes IS 'History of AI outfit customization operations';
COMMENT ON TABLE public.image_expansions IS 'History of aspect ratio expansion operations';
COMMENT ON TABLE public.image_upscaling IS 'History of 4K upscaling operations';
