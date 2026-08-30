ALTER TABLE public.users RENAME COLUMN phone TO phone_number;

UPDATE public.users u
SET phone_number = p.phone
FROM public.profiles p
WHERE u.id = p.user_id AND u.phone_number IS NULL AND p.phone IS NOT NULL;

CREATE INDEX CONCURRENTLY idx_orders_created_at ON public.orders (created_at);

DROP TABLE public.legacy_flags;

INSERT INTO public.products (name, price, stock_quantity, category_id)
VALUES ('Wireless Mouse', 24.99, 150, 1);
