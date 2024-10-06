# First loop: Collect all answers
NR % 3 == 2 {
  question = $0
  getline
  answer = $0
  #gsub(/\(.*\)/, "", answer)  # Remove parentheses from the answer text
  gsub(/"/, "", question)     # Remove quotes from the question text
  questions[++count] = question
  answers[count] = answer
}

# Second loop: Generate the JSON format output
END {
  for (i = 1; i <= count; i++) {
    correct_answer = answers[i]

    # Pick 3 random incorrect answers from the answers array
    rand1 = answers[int(1 + rand() * count)]
    rand2 = answers[int(1 + rand() * count)]
    rand3 = answers[int(1 + rand() * count)]

    # Ensure no repetition of the correct answer in incorrect choices
    while (rand1 == correct_answer) rand1 = answers[int(1 + rand() * count)]
    while (rand2 == correct_answer || rand2 == rand1) rand2 = answers[int(1 + rand() * count)]
    while (rand3 == correct_answer || rand3 == rand1 || rand3 == rand2) rand3 = answers[int(1 + rand() * count)]

    # Generate a random position for the correct answer
    correct_pos = int(1 + rand() * 4)

    # Output the question and answers in JSON format
    printf "{\n  \"question\": \"What does \x27%s\x27 mean?\",\n  \"options\": [\n", questions[i]
    for (j = 1; j <= 4; j++) {
      if (j == correct_pos) {
        printf "    { \"text\": \"%s\", \"correct\": true }", correct_answer
      } else if (j == 1) {
        printf "    { \"text\": \"%s\", \"correct\": false }", rand1
      } else if (j == 2) {
        printf "    { \"text\": \"%s\", \"correct\": false }", rand2
      } else {
        printf "    { \"text\": \"%s\", \"correct\": false }", rand3
      }
      if (j < 4) printf ",\n"
      else printf "\n"
    }
    printf "  ]\n},\n"
  }
}