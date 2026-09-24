FROM node:20-bookworm-slim

# Version du bot à déployer. Mettre à jour cette valeur après chaque nouveau
# push important dans OVL-MD-V2 afin d'invalider le cache Docker de Render.
ARG OVL_COMMIT=aacd32c

RUN apt-get update && apt-get install -y \
    ffmpeg \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 --branch main --single-branch \
      https://github.com/batouroudiallo52-debug/OVL-MD-V2.git /ovl_bot \
    && test "$(git -C /ovl_bot rev-parse --short HEAD)" = "$OVL_COMMIT" \
    && test -f /ovl_bot/cmd/Quiz.js \
    && grep -q "sciences" /ovl_bot/cmd/Quiz.js \
    && grep -q '"category": "histoire"' /ovl_bot/lib/quiz_questions.json

ENV NODE_ENV=production
WORKDIR /ovl_bot
RUN npm install --omit=dev

EXPOSE 8000
CMD ["npm", "run", "Ovl"]
