# استفاده از نسخه سبک Alpine
FROM nginx:alpine

# نصب پکیج برای تنظیم ساعت (اختیاری)
RUN apk add --no-cache tzdata

# حذف کانفیگ پیش‌فرض
RUN rm /etc/nginx/conf.d/default.conf

# کپی فایل تنظیمات شما
COPY nginx.conf /etc/nginx/conf.d/api-proxy.conf

# تنظیم تایم‌زون به تهران
RUN cp /usr/share/zoneinfo/Asia/Tehran /etc/localtime && \
    echo "Asia/Tehran" > /etc/timezone

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]