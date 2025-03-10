FROM node:20-alpine as builder
WORKDIR /app
ENV NODE_ENV=production

COPY package.json pnpm-lock.yaml ./
RUN npm install -g pnpm && pnpm install

COPY . .
RUN pnpm build

FROM node:20-alpine
WORKDIR /app
ENV NODE_ENV=production

# Install serve globally
RUN npm install -g serve

COPY package.json pnpm-lock.yaml ./
RUN npm install -g pnpm && pnpm install --prod

COPY --from=builder /app/dist dist
EXPOSE 4173
CMD ["serve", "-s", "dist", "-l", "4173"]