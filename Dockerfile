# --- FASE DE BUILD (Compilação) ---
# Usamos uma imagem Node.js completa para ter as ferramentas de build (TypeScript)
FROM node:lts-alpine AS builder

# Define o diretório de trabalho dentro do contêiner para esta fase
WORKDIR /app

# Copia os arquivos de configuração do projeto e dependências (package.json, etc.)
# Isso aproveita o cache do Docker, se as dependências não mudarem, essa fase é mais rápida
COPY package*.json ./

# Instala as dependências, incluindo as de desenvolvimento (TypeScript, ts-node, etc.)
RUN npm install

# Copia todo o código-fonte da aplicação
COPY . .

# Compila o código TypeScript para JavaScript
# Certifique-se de que você tem um script "build" no seu package.json (geralmente "tsc")
RUN npm run build


# --- FASE DE PRODUÇÃO (Execução da Aplicação) ---
# Usamos uma imagem Node.js mais leve para produção, sem ferramentas de build desnecessárias
FROM node:lts-alpine

# Define o diretório de trabalho final
WORKDIR /app

# Copia apenas os arquivos package.json e package-lock.json da fase de build
# Isso garante que as dependências corretas sejam instaladas para produção
COPY --from=builder /app/package*.json ./

# Instala apenas as dependências de PRODUÇÃO (sem --save-dev)
# Isso torna a imagem final menor
RUN npm install --only=production

# Copia APENAS o código compilado (pasta 'dist') da fase de build para a fase de produção
COPY --from=builder /app/dist ./dist

# Se houver outros arquivos estáticos que sua aplicação precisa em produção (ex: public/)
# COPY --from=builder /app/public ./public

# Exponha a porta em que sua aplicação Node.js irá rodar (Ex: 3000)
EXPOSE 3000

# Comando para iniciar a aplicação quando o contêiner for executado
# Deve apontar para o arquivo JavaScript compilado na pasta 'dist'
CMD [ "node", "dist/index.js" ]