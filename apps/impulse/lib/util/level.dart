const int maxLvl = 10;

int getScoreForLevel(int level) {
  return ((level * (level + 1) / 2) * 1000).toInt();
}

int currentLevel(int score) {
  int level = 0;
  while (getScoreForLevel(level) <= score || level > maxLvl) {
    level++;
  }
  return level;
}

int currentLevelXPRequirement(int score) {
  int level = currentLevel(score);
  return getScoreForLevel(level + 1) - getScoreForLevel(level);
}

int missingToNextLevel(int score) {
  int currentLvl = currentLevel(score);
  if (currentLvl >= maxLvl) {
    return 0;
  }
  return currentLevelXPRequirement(score) - score;
}
