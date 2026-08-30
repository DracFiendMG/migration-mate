DELETE FROM public.products
WHERE id = (
    SELECT id
    FROM public.products
    WHERE name = 'Bluetooth Keyboard'
      AND price = 39.99
      AND stock_quantity = 80
      AND category_id = 1
    ORDER BY created_at DESC
    LIMIT 1
);
