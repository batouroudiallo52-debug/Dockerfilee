FROM node:20-bookworm-slim

# Commit exact du bot à déployer depuis OVL-MD-V2.
# Modifier cette valeur après chaque mise à jour du dépôt source. Comme l'ARG
# est utilisé dans le RUN ci-dessous, Docker invalide le cache lorsque le
# commit change et Render reconstruit l'image avec le nouveau code.
ARG OVL_COMMIT=4a2d008e15a2fa6050579f6de7778d2056ef97de
ARG OVL_REPO=https://github.com/batouroudiallo52-debug/OVL-MD-V2.git

RUN apt-get update && apt-get install -y \
    ffmpeg \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN git init /ovl_bot \
    && git -C /ovl_bot remote add origin "$OVL_REPO" \
    && git -C /ovl_bot fetch --depth 1 origin "$OVL_COMMIT" \
    && git -C /ovl_bot checkout --detach FETCH_HEAD \
    && test "$(git -C /ovl_bot rev-parse HEAD)" = "$OVL_COMMIT" \
    && test -f /ovl_bot/cmd/Quiz.js \
    && test -f /ovl_bot/lib/quiz_questions.json \
    && grep -q "QUESTION_LIMITS = \[10, 20, 30\]" /ovl_bot/cmd/Quiz.js \
    && grep -q "QUESTION_SELECTIONS" /ovl_bot/cmd/Quiz.js \
    && grep -q "pendingQuizSelections" /ovl_bot/cmd/Quiz.js \
    && grep -q "function questionKey" /ovl_bot/cmd/Quiz.js \
    && grep -q "questionQueue" /ovl_bot/cmd/Quiz.js \
    && grep -q "shuffleQuestions" /ovl_bot/cmd/Quiz.js \
    && grep -q "total > pool.length" /ovl_bot/cmd/Quiz.js \
    && grep -q "mix: 'Toutes catégories'" /ovl_bot/cmd/Quiz.js \
    && grep -q "ANSWER_TIMEOUT = 10_000" /ovl_bot/cmd/Quiz.js \
    && grep -q "Temps limite : \\*10 secondes\\*" /ovl_bot/cmd/Quiz.js \
    && grep -q "Chaque quiz utilise des questions nouvelles" /ovl_bot/cmd/Quiz.js \
    && grep -q "gagne \\*1 point\\*" /ovl_bot/cmd/Quiz.js \
    && grep -q "anime" /ovl_bot/cmd/Quiz.js \
    && grep -q "culture" /ovl_bot/cmd/Quiz.js \
    && grep -q "foot" /ovl_bot/cmd/Quiz.js \
    && grep -q "horreur" /ovl_bot/cmd/Quiz.js \
    && grep -q "kpop" /ovl_bot/cmd/Quiz.js \
    && grep -q "CATEGORY_IMAGES" /ovl_bot/cmd/Quiz.js \
    && grep -q "hasImageOption" /ovl_bot/cmd/Quiz.js \
    && grep -q "commons.wikimedia.org/w/api.php" /ovl_bot/cmd/Quiz.js \
    && grep -q "imageSearchQuery" /ovl_bot/cmd/Quiz.js \
    && grep -q '"category": "anime"' /ovl_bot/lib/quiz_questions.json \
    && grep -q '"category": "culture"' /ovl_bot/lib/quiz_questions.json \
    && grep -q '"category": "foot"' /ovl_bot/lib/quiz_questions.json \
    && grep -q '"category": "horreur"' /ovl_bot/lib/quiz_questions.json \
    && grep -q '"category": "kpop"' /ovl_bot/lib/quiz_questions.json \
    && node --check /ovl_bot/cmd/Quiz.js \
    && node -e "const q=JSON.parse(require('fs').readFileSync('/ovl_bot/lib/quiz_questions.json', 'utf8')); const allowed=new Set(['anime','culture','foot','horreur','kpop']); if (!q.length || q.some(x => !allowed.has(x.category)) || new Set(q.map(x => x.category)).size !== allowed.size) process.exit(1);"

ENV NODE_ENV=production PORT=8000
WORKDIR /ovl_bot
RUN npm install --omit=dev

EXPOSE 8000
CMD ["npm", "run", "Ovl"]
