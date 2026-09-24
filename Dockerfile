FROM node:20-bookworm-slim

# Version exacte du bot à déployer.
# Modifier cette valeur après chaque mise à jour de OVL-MD-V2 : comme elle est
# utilisée dans la commande RUN ci-dessous, Docker invalide le cache et Render
# reconstruit l'image avec le nouveau commit.
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
    && grep -q '"category": "histoire"' /ovl_bot/lib/quiz_questions.json \
    && grep -q "geographie" /ovl_bot/cmd/Quiz.js \
    && grep -q "technologie" /ovl_bot/cmd/Quiz.js \
    && grep -q "litterature" /ovl_bot/cmd/Quiz.js \
    && grep -q "nature" /ovl_bot/cmd/Quiz.js \
    && grep -q '"category": "geographie"' /ovl_bot/lib/quiz_questions.json \
    && grep -q '"category": "technologie"' /ovl_bot/lib/quiz_questions.json \
    && grep -q '"category": "litterature"' /ovl_bot/lib/quiz_questions.json \
    && grep -q '"category": "nature"' /ovl_bot/lib/quiz_questions.json

ENV NODE_ENV=production
WORKDIR /ovl_bot
RUN npm install --omit=dev

EXPOSE 8000
CMD ["npm", "run", "Ovl"]
