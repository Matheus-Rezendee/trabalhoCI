# Etapa de build
FROM node:22-alpine AS builder

WORKDIR /usr/src/app

# Copia package.json e package-lock.json
COPY package*.json ./

# Instala apenas dependências de produção
RUN npm ci --omit=dev

# Copia o restante do código
COPY . .

# Etapa final
FROM node:22-alpine

WORKDIR /usr/src/app

# Copia node_modules do builder
COPY --from=builder /usr/src/app/node_modules ./node_modules

# Copia o restante do código
COPY --from=builder /usr/src/app ./

# Expõe a porta do servidor
EXPOSE 3000

# Comando para iniciar a aplicação
CMD ["node", "server.js"]
