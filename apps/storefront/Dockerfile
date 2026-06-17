FROM node:18-alpine AS builder

WORKDIR /app

RUN apk add --no-cache git

RUN git clone --depth 1 --branch 3.x https://github.com/saleor/storefront.git .

RUN npm install --legacy-peer-deps

ENV NEXT_PUBLIC_API_URL=https://api.samadov.xyz/graphql/
ENV NEXT_PUBLIC_CHECKOUT_APP_URL=https://api.samadov.xyz/

RUN npm run build

FROM node:18-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production

COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/public ./public

EXPOSE 3000
CMD ["node", "server.js"]
