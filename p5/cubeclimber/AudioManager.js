class AudioManager {
  constructor(musicVol, sfxVol) {
    this.musicGain = new p5.Gain();
    this.sfxGain = new p5.Gain();
    
    this.musicGain.amp(musicVol);
    this.sfxGain.amp(sfxVol);

    this.baseScale = [0, 2, 4, 5, 7, 9, 11]; // C Major scale intervals
    this.currentKey = 60; // Start at Middle C
    this.melodyIndex = 0;
    this.notePlayProbability = 0.80;

    // A p5.Part is a timeline for scheduling events, replacing the Beads Clock.
    // The first argument to the callback function is the time the note should play.
    this.musicLoop = new p5.Part((time) => {
      this.playMelodyNote(time);
    }, 1/4); // The "1/4" means it triggers on every quarter note.

    this.musicLoop.setBPM(60); // We'll adjust this tempo later
  }

  playMelodyNote(time) {
    if (random(1) < this.notePlayProbability) {
      let noteOffset = this.baseScale[this.melodyIndex % this.baseScale.length];

      // Randomly jump octaves occasionally
      let octaveRand = random(1);
      if (octaveRand < 0.05) noteOffset += 12;
      else if (octaveRand < 0.08) noteOffset -= 12;

      let freq = midiToFreq(this.currentKey + noteOffset);

      // Create an oscillator and an envelope for each note
      let osc = new p5.Oscillator('triangle');
      let env = new p5.Envelope();

      // Configure the envelope (attack, decay, sustain, release)
      env.setADSR(0.01, 0.1, 0.2, 0.2);
      env.setRange(0.2, 0); // Attack level, release level

      osc.amp(env);
      osc.freq(freq);
      
      // Connect the oscillator to our music gain node
      osc.connect(this.musicGain);

      osc.start(time);
      env.play(osc, time); // The envelope controls the oscillator
      
      // Update melody index for the next note
      let r = random(1);
      if (r < 0.65) this.melodyIndex++;
      else if (r < 0.80) { /* hold note */ } 
      else if (r < 0.90) this.melodyIndex += 2;
      else this.melodyIndex = max(0, this.melodyIndex - 1);
    }
  }

  updateVolumes(musicVol, sfxVol) {
    this.musicGain.amp(musicVol, 0.1); // 0.1 is a short ramp time
    this.sfxGain.amp(sfxVol, 0.1);
  }

  adjustTempoAndKey(remainingMillis) {
    let newKey;
    let newBPM;

    if (remainingMillis > 120000) { // Over 2 minutes left
      newKey = 60; // C
      newBPM = 60;
      this.notePlayProbability = 0.85;
    } else if (remainingMillis > 60000) { // Over 1 minute left
      newKey = 65; // F
      newBPM = 90;
      this.notePlayProbability = 0.75;
    } else { // Less than 1 minute
      newKey = 67; // G
      newBPM = 120;
      this.notePlayProbability = 0.65;
    }

    this.currentKey = newKey;
    this.musicLoop.setBPM(newBPM);
  }

  playSFX(soundFile) {
    if (soundFile && soundFile.isLoaded()) {
      // Instead of connecting to a gain node, we can set the output volume directly
      // while respecting the sfxGain level.
      soundFile.setVolume(this.sfxGain.amp().value);
      soundFile.play();
    }
  }

  stopMusic() {
    this.musicLoop.pause();
  }

  resumeMusic() {
    this.musicLoop.loop(); // Use .loop() to start/resume
  }
}
