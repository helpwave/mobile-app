import 'dart:math';

const int maxLvl = 10;

int getScoreForLevel(int level) {
  return 1000*level;
}

int currentLevel(int score) {
  int level = min(maxLvl, score ~/ 1000);
  return level;
}

int currentLevelXPRequirement(int score) {
  int level = currentLevel(score);
  return (level) * 1000;
}

int missingToNextLevel(int score) {
  int currentLvl = currentLevel(score);
  if (currentLvl >= maxLvl) {
    return 0;
  }
  return (currentLvl +1) * 1000 - score;
}
