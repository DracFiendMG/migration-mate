ALTER TABLE public.users RENAME COLUMN phone_number TO phone;

UPDATE public.users
SET phone = NULL
WHERE id IN (
    SELECT u.id
    FROM public.users u
    JOIN public.profiles p ON u.id = p.user_id
    WHERE u.phone IS NOT NULL AND p.phone IS NOT NULL
);

DROP INDEX IF EXISTS idx_orders_created_at;

CREATE TABLE public.legacy_flags (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    flag_name text NOT NULL,
    is_active bool DEFAULT false NOT NULL,
    created_at timestamptz DEFAULT now() NOT NULL
);

DELETE FROM public.products
WHERE name = 'Wireless Mouse' AND price = 24.99 AND stock_quantity = 150 AND category_id = 1;
