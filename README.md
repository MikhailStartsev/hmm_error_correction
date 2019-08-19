# HMM-based error correction for automatically labelled eye movements
Trainable hidden Markov model-based correction of errors in automatic eye movement label sequences

See train_and_test_run() function for the main interface.
See base_functions/load_train_and_test_data() for help on structuring the data (has to be similar to `example_data` in folder structure)

### Contact: mikhail.startsev@tum.de

### BibTeX reference:

```
@inproceedings{startsev2019improving,
  title={Improving the state of the art in eye movement event detection via trainable label correction},
  author={Startsev, Mikhail and Dorr, Michael},
  booktitle={Book of Abstracts: 20th European Conference on Eye Movemement, 18-22 August 2019, Alicante, Spain},
  pages={135-135},
  year={2019}
}
```

### Abstract:

Modern computational methods such as machine learning can improve eye movement detection. Several deep
learning approaches have recently emerged that further pushed the boundaries of algorithmic classification.
To tackle the detector quality assessment not just as a numerical problem, but to rather estimate how suitable
the detected events are for subsequent analyses, event-level instead of sample-level evaluation metrics have
been developed. In order to filter out unlikely or impossible events, current algorithms often rely on handcrafted heuristics. In contrast to this, we propose a post-processing step to automatically learn the constraints
via simple statistical modelling with hidden Markov models. Our approach learns from data to correct errors
in algorithmic labelling, automatically adapting to the analysed labels. We tested this approach on large-scale
data sets of free-viewing gaze data from dynamic natural scenes and in application to the outputs of a number
of classical and state-of-the-art eye movement classifiers. Even though these performed very well on samplelevel classification already, event-level metrics were noticeably improved. For example, we considered a stateof-the-art sequence-modelling deep learning eye movement classifier (Startsev et al., BRM, 2018) that already
used a large temporal context. In principle, it thus could learn sequential inter-dependencies in the labels
directly. However, our trainable correction yielded noticeable improvements in all event-level quality measures
for all eye movement types: F1 scores, for instance, showed an absolute increase of 1.5%, 3%, and 5% for
fixations, saccades, and smooth pursuits, respectively. 
