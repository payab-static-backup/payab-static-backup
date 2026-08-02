#!/bin/bash
set -e

BACKUP_DIR="backup"
MIN_FILES=50
MIN_SIZE_KB=5000

echo "=== بررسی سلامت بک‌آپ ==="

if [ ! -d "$BACKUP_DIR" ]; then
  echo "❌ خطا: پوشه backup اصلاً ساخته نشده."
  exit 1
fi

if [ ! -f "$BACKUP_DIR/payab.ir/index.html" ]; then
  echo "❌ خطا: فایل index.html صفحه اصلی پیدا نشد."
  exit 1
fi

INDEX_SIZE=$(stat -c%s "$BACKUP_DIR/payab.ir/index.html" 2>/dev/null || echo 0)
if [ "$INDEX_SIZE" -lt 1000 ]; then
  echo "❌ خطا: index.html خیلی کوچک است (شاید صفحه خطا دانلود شده، نه صفحه واقعی)."
  exit 1
fi

FILE_COUNT=$(find "$BACKUP_DIR" -name "*.html" | wc -l)
echo "تعداد فایل‌های HTML دانلودشده: $FILE_COUNT"

if [ "$FILE_COUNT" -lt "$MIN_FILES" ]; then
  echo "❌ خطا: تعداد فایل‌ها ($FILE_COUNT) کمتر از حد انتظار ($MIN_FILES) است."
  exit 1
fi

TOTAL_SIZE_KB=$(du -sk "$BACKUP_DIR" | cut -f1)
echo "حجم کل بک‌آپ: ${TOTAL_SIZE_KB} KB"

if [ "$TOTAL_SIZE_KB" -lt "$MIN_SIZE_KB" ]; then
  echo "❌ خطا: حجم کل بک‌آپ ($TOTAL_SIZE_KB KB) کمتر از حد انتظار ($MIN_SIZE_KB KB) است."
  exit 1
fi

echo "✅ بررسی موفق بود — بک‌آپ سالم به‌نظر می‌رسد."
exit 0
