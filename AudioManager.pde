import beads.*;

class AudioManager {
  AudioContext ac;
  Gain masterGain;
  Gain musicGain, sfxGain;
  Clock musicClock;
  float lastInterval;

  int[] baseScale = {0, 2, 4, 5, 7, 9, 11};
  int currentKey = 60;
  int melodyIndex = 0;

  float notePlayProbability = 0.80f;

  AudioManager(float musicVol, float sfxVol) {
    ac = new AudioContext();
    masterGain = new Gain(ac, 2, 1.0);
    musicGain = new Gain(ac, 2, musicVol);
    sfxGain = new Gain(ac, 2, sfxVol);
    masterGain.addInput(musicGain);
    masterGain.addInput(sfxGain);
    ac.out.addInput(masterGain);
    ac.start();

    lastInterval = 1000;
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

    if (random(1) < notePlayProbability) {
      int noteOffset = baseScale[melodyIndex % baseScale.length];

      float octaveRand = random(1);
      if (octaveRand < 0.05) {
        noteOffset += 12;
      } else if (octaveRand < 0.08) {
        noteOffset -= 12;
      }

      float freq = midiToFreq(currentKey + noteOffset);

      WavePlayer wp = new WavePlayer(ac, freq, Buffer.TRIANGLE);
      Envelope env = new Envelope(ac, 0.2f);
      final Gain g = new Gain(ac, 2, env);
      g.addInput(wp);
      musicGain.addInput(g);

      env.addSegment(0.0f, 150.0f, new Bead() {
        public void messageReceived(Bead message) {
          g.kill();
        }
      });

      float r = random(1);
      if (r < 0.65) {
        melodyIndex++;
      } else if (r < 0.80) {
      } else if (r < 0.90) {
        melodyIndex += 2;
      } else {
        melodyIndex = max(0, melodyIndex - 1);
      }
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

    if (remainingMillis > 120000) {
      newKey = 60;
      newInterval = 2000;
      notePlayProbability = 0.85f;
    } else if (remainingMillis > 60000) {
      newKey = 65;
      newInterval = 1000;
      notePlayProbability = 0.75f;
    } else {
      newKey = 67;
      newInterval = 500;
      notePlayProbability = 0.65f;
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
    if (ac == null || s == null) return;

    SamplePlayer player = new SamplePlayer(ac, s);
    player.setKillOnEnd(true);
    sfxGain.addInput(player);
    player.start();
  }

  void stopMusic() {
    if (musicClock != null) musicClock.pause(true);
  }

  void resumeMusic() {
    if (musicClock != null) musicClock.start();
  }

  public void stop() {
    if (ac != null) {
      ac.stop();
    }
  }
}
