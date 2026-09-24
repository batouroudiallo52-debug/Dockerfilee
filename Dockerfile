FROM node:20-bookworm-slim

# Version exacte du bot à déployer.
# Modifier cette valeur après chaque mise à jour de OVL-MD-V2 : comme elle est
# utilisée dans la commande RUN ci-dessous, Docker invalide le cache et Render
# reconstruit l'image avec le nouveau commit.
ARG OVL_COMMIT=3f6d662

RUN apt-get update && apt-get install -y \
    ffmpeg \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 --branch main --single-branch \
      https://github.com/batouroudiallo52-debug/OVL-MD-V2.git /ovl_bot \
    && test "$(git -C /ovl_bot rev-parse --short HEAD)" = "$OVL_COMMIT" \
    && test -f /ovl_bot/cmd/Quiz.js \
    && test -f /ovl_bot/lib/quiz_questions.json \
    && grep -q "QUESTION_LIMITS = \[10, 30, 60, 100\]" /ovl_bot/cmd/Quiz.js \
    && grep -q "anime" /ovl_bot/cmd/Quiz.js \
    && grep -q "culture" /ovl_bot/cmd/Quiz.js \
    && grep -q "foot" /ovl_bot/cmd/Quiz.js \
    && grep -q "horreur" /ovl_bot/cmd/Quiz.js \
    && grep -q "kpop" /ovl_bot/cmd/Quiz.js \
    && grep -q "musique" /ovl_bot/cmd/Quiz.js \
    && grep -q "CATEGORY_IMAGES" /ovl_bot/cmd/Quiz.js \
    && grep -q "hasImageOption" /ovl_bot/cmd/Quiz.js \
    && grep -q '"category": "anime"' /ovl_bot/lib/quiz_questions.json \
    && grep -q '"category": "culture"' /ovl_bot/lib/quiz_questions.json \
    && grep -q '"category": "foot"' /ovl_bot/lib/quiz_questions.json \
    && grep -q '"category": "horreur"' /ovl_bot/lib/quiz_questions.json \
    && grep -q '"category": "kpop"' /ovl_bot/lib/quiz_questions.json \
    && grep -q '"category": "musique"' /ovl_bot/lib/quiz_questions.json

ENV NODE_ENV=production
WORKDIR /ovl_bot
RUN npm install --omit=dev

EXPOSE 8000
CMD ["npm", "run", "Ovl"]
