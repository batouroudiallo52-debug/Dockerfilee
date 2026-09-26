FROM node:20-bookworm-slim

# Commit exact du bot à déployer depuis OVL-MD-V2.
# Modifier cette valeur après chaque mise à jour du dépôt source. Comme l'ARG
# est utilisé dans le RUN ci-dessous, Docker invalide le cache lorsque le
# commit change et Render reconstruit l'image avec le nouveau code.
ARG OVL_COMMIT=01d3571
ARG OVL_REPO=https://github.com/batouroudiallo52-debug/OVL-MD-V2.git

RUN apt-get update && apt-get install -y \
    ffmpeg \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 --branch main --single-branch "$OVL_REPO" /ovl_bot \
    && test "$(git -C /ovl_bot rev-parse --short HEAD)" = "$OVL_COMMIT" \
    && test -f /ovl_bot/cmd/Quiz.js \
    && test -f /ovl_bot/lib/quiz_questions.json \
    && test -f /ovl_bot/lib/quiz_true_false.json \
    && grep -q "TRUE_FALSE_FILE" /ovl_bot/cmd/Quiz.js \
    && grep -q "true-false" /ovl_bot/cmd/Quiz.js \
    && grep -q "vrai-faux" /ovl_bot/cmd/Quiz.js \
    && grep -q "QUESTION_LIMITS = \[10, 30, 60, 100\]" /ovl_bot/cmd/Quiz.js \
    && grep -q "anime" /ovl_bot/cmd/Quiz.js \
    && grep -q "culture" /ovl_bot/cmd/Quiz.js \
    && grep -q "foot" /ovl_bot/cmd/Quiz.js \
    && grep -q "horreur" /ovl_bot/cmd/Quiz.js \
    && grep -q "kpop" /ovl_bot/cmd/Quiz.js \
    && grep -q "musique" /ovl_bot/cmd/Quiz.js \
    && grep -q "films:" /ovl_bot/cmd/Quiz.js \
    && grep -q "geographie:" /ovl_bot/cmd/Quiz.js \
    && grep -q "histoire:" /ovl_bot/cmd/Quiz.js \
    && grep -q "litterature:" /ovl_bot/cmd/Quiz.js \
    && grep -q "nature:" /ovl_bot/cmd/Quiz.js \
    && grep -q "sciences:" /ovl_bot/cmd/Quiz.js \
    && grep -q "technologie:" /ovl_bot/cmd/Quiz.js \
    && grep -q "CATEGORY_IMAGES" /ovl_bot/cmd/Quiz.js \
    && grep -q "hasImageOption" /ovl_bot/cmd/Quiz.js \
    && grep -q "commons.wikimedia.org/w/api.php" /ovl_bot/cmd/Quiz.js \
    && grep -q "imageSearchQuery" /ovl_bot/cmd/Quiz.js \
    && grep -q '"category": "anime"' /ovl_bot/lib/quiz_questions.json \
    && grep -q '"category": "culture"' /ovl_bot/lib/quiz_questions.json \
    && grep -q '"category": "foot"' /ovl_bot/lib/quiz_questions.json \
    && grep -q '"category": "horreur"' /ovl_bot/lib/quiz_questions.json \
    && grep -q '"category": "kpop"' /ovl_bot/lib/quiz_questions.json \
    && grep -q '"category": "musique"' /ovl_bot/lib/quiz_questions.json \
    && grep -q '"category": "films"' /ovl_bot/lib/quiz_questions.json \
    && grep -q '"category": "geographie"' /ovl_bot/lib/quiz_questions.json \
    && grep -q '"category": "histoire"' /ovl_bot/lib/quiz_questions.json \
    && grep -q '"category": "litterature"' /ovl_bot/lib/quiz_questions.json \
    && grep -q '"category": "nature"' /ovl_bot/lib/quiz_questions.json \
    && grep -q '"category": "sciences"' /ovl_bot/lib/quiz_questions.json \
    && grep -q '"category": "technologie"' /ovl_bot/lib/quiz_questions.json

ENV NODE_ENV=production
WORKDIR /ovl_bot
RUN npm install --omit=dev

EXPOSE 8000
CMD ["npm", "run", "Ovl"]
