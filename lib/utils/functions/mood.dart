enum Mood {
  happy,
  sad,
  angry,
  excited,
  relaxed,
  bored,
}

//Mood Extention
extension MoodExtention on Mood {
  String get name{
    switch(this){
      case Mood.happy:
        return 'Happy';
      case Mood.sad:
        return 'Sad';
      case Mood.angry:
        return 'Angry';
      case Mood.excited:
        return 'Excited';
      case Mood.relaxed:
        return 'Relaxed';
      case Mood.bored:
        return 'Bored';
    }
  }

  String get emoji {
    switch(this){
      case Mood.happy:
        return "😀";
      case Mood.sad:
        return "😢";
      case Mood.angry:
        return "😠";
      case Mood.excited:
        return "😃";
      case Mood.relaxed:
        return "😌";
      case Mood.bored:
        return "😐";
    }
  }

  static Mood fromString(String moodString) {
    return Mood.values.firstWhere(
      (mood) => mood.name.toLowerCase() == moodString.toLowerCase(),
      orElse: () => Mood.happy, // Default to happy if no match found
    );
  }
}