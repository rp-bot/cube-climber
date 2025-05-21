import beads.*;

class AudioManager {
  AudioContext ac;
  Gain masterGain;
  Gain musicGain, sfxGain;
  Clock musicClock;
  float lastInterval;

  int[] baseScale = {0, 2, 4, 5, 7, 9, 11}; // Major scale in semitones
  int currentKey = 60; // MIDI note (Middle C)
  int melodyIndex = 0; // Index for the baseScale

  // --- Variables for new variations ---
  float notePlayProbability = 0.80f; // 80% chance to play a note, 20% for a rest

  AudioManager(float musicVol, float sfxVol) {
    ac = new AudioContext();
    masterGain = new Gain(ac, 2, 1.0);
    musicGain = new Gain(ac, 2, musicVol);
    sfxGain = new Gain(ac, 2, sfxVol);
    masterGain.addInput(musicGain);
    masterGain.addInput(sfxGain);
    ac.out.addInput(masterGain);
    ac.start();

    // User's preferred starting interval
    lastInterval = 1000; // This will be updated by adjustTempoAndKey
    setupClock(lastInterval);
  }

  void setupClock(float interval) {
    if (musicClock != null) {
      musicClock.pause(true);
      if (ac != null && ac.out != null) {
        ac.out.removeDependent(musicClock);
      }
    }
    musicClock = new Clock(ac, interval);
    musicClock.addMessageListener(new Bead() {
      void messageReceived(Bead message) {
        playMelodyNote();
      }
    });
    if (ac != null && ac.out != null) {
      ac.out.addDependent(musicClock);
    }
    musicClock.start();
  }

  void playMelodyNote() {
    if (ac == null) return;

    // --- 1. Rhythmic Variation: Decide if we play a note or rest ---
    if (random(1) < notePlayProbability) {
      // --- We are playing a note this tick ---

      // --- 2. Melodic Variation: Determine the note offset ---
      int noteOffset = baseScale[melodyIndex % baseScale.length];

      // Optional: Add random octave jumps for more pitch variation
      float octaveRand = random(1);
      if (octaveRand < 0.05) { // 5% chance for octave up
        noteOffset += 12;
      } else if (octaveRand < 0.08) { // 3% chance for octave down (be careful with very low notes)
        noteOffset -= 12;
      }
      // --- End of Octave Jump Variation ---

      float freq = midiToFreq(currentKey + noteOffset);

      WavePlayer wp = new WavePlayer(ac, freq, Buffer.TRIANGLE);
      Envelope env = new Envelope(ac, 0.2f);
      final Gain g = new Gain(ac, 2, env);
      g.addInput(wp);
      musicGain.addInput(g);

      env.addSegment(0.0f, 150.0f, new Bead() {
        public void messageReceived(Bead message) {
          g.kill(); // Ensure g is not null before killing
        }
      });

      // --- Melodic Variation: Decide how melodyIndex advances for the NEXT note ---
      float r = random(1);
      if (r < 0.65) {       // 65% chance: normal next note in scale
        melodyIndex++;
      } else if (r < 0.80) { // 15% chance: repeat current note (so melodyIndex effectively doesn't change for the next played note)
        // No change to melodyIndex this time
      } else if (r < 0.90) { // 10% chance: skip a note in the scale
        melodyIndex += 2;
      } else {                // 10% chance: small step back in the scale
        melodyIndex = max(0, melodyIndex - 1); // Prevent negative index if desired, or handle wrap-around
        // For wrap-around backward: melodyIndex = (melodyIndex - 1 + baseScale.length) % baseScale.length;
      }
      // --- End of Melodic Index Advancement Variation ---

    } else {
      // --- It's a rest: Do nothing for sound ---
      // melodyIndex does not advance here, so the next potential note will be the same one
      // If you want the melody to "progress" even over rests, you could advance melodyIndex here too.
    }
  }

  float midiToFreq(int midi) {
    return 440.0f * pow(2, (midi - 69) / 12.0f);
  }

  void updateVolumes(float musicVol, float sfxVol) {
    if (musicGain != null) musicGain.setGain(musicVol);
    if (sfxGain != null) sfxGain.setGain(sfxVol);
  }

  void adjustTempoAndKey(int remainingMillis) {
    int newKey;
    float newInterval;

    // User's preferred intervals (these are quite slow, which gives space for rests)
    if (remainingMillis > 120000) {
      newKey = 60; // C
      newInterval = 2000;
      notePlayProbability = 0.85f; // Higher chance to play notes when music is slow
    } else if (remainingMillis > 60000) {
      newKey = 65; // F
      newInterval = 1000;
      notePlayProbability = 0.75f; // Medium chance
    } else {
      newKey = 67; // G
      newInterval = 500;
      notePlayProbability = 0.65f; // Lower chance (more rests) when music is faster, creating intensity
    }

    if (newKey != currentKey) currentKey = newKey;
    if (abs(newInterval - lastInterval) > 10) {
      lastInterval = newInterval;
      if (ac != null) {
        setupClock(newInterval);
      }
    }
  }

  void playSFX(Sample s) {
    if (ac == null || s == null) return; // Guard clause

    SamplePlayer player = new SamplePlayer(ac, s);
    player.setKillOnEnd(true); // Good practice: tells player to kill itself when done
    sfxGain.addInput(player);
    // player.start(); // SamplePlayer automatically starts by default unless configured otherwise.
                       // If it doesn't auto-start, uncomment this.
                       // Typically, for one-shot samples, just adding it to a gain that is
                       // part of the main audio graph is enough, or if it needs an explicit start:
    player.start();
  }

  void stopMusic() {
    if (musicClock != null) musicClock.pause(true);
  }

  void resumeMusic() {
    if (musicClock != null) musicClock.start();
  }

  // Call this method when your sketch is closing to clean up AudioContext
  public void stop() {
      if (ac != null) {
          ac.stop();
      }
  }
}
