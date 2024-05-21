# perception
 norns time shifting script based on animal CFF (critical flicker fusion) and their perception of the world

 ![main_gui](/assets/gui.png)


sample player and looper


## HARDWARE / INSTALL

**required**

- [norns](https://github.com/p3r7/awesome-monome-norns) (240424 or later)
  - **the required norns version is recent, please be sure that your norns is up-to-date before launching**

install directly from gitHub

or

in maiden type:

```
;install https://github.com/2roundrobins/perception
```
## ANIMAL CFF
there are quite a few studies suggesting quite noticable correlation between **CFF** (_critical-flicker fusion frequency_) and the perception of time and temporal resolution  within the animal kingdom, including humans. although CFF is mostly linked to a visual threshold, where animals ceases to perceive flickering of a light source and sees a continous stream of light (Inger, 2014), the differenct perception of time has been assesed over different sensory modalities, including auditory (Fink, 2006).

thus, my goal was to create a sample player & looper, which takes not only CFF data, but also hearing range of different species into time-mangling consideration - essentially shifting the listeners auditory perception to that of a different species.

### featured animal species
the script features the following animal species;

| species | scientific name | CFF |
| ------------ | ---------------- |----- |
| Cane Toad | _Bufo marinus_   |6.7 |
| Green Frog | _Rana clamitans_ |21 |
| Rainbow Trout | _Oncorhynchus mykiss_ |27 |
| Harp Seal | _Pagophilus groenlandicus_ |32.7 |
|Brown Rat| _Rattus norvegicus_ |39 |
| Great-Horned Owl| _Bubo virginianus_ |45 |
|Cat |  _Felis catus_ |55 |
| Human | _Homo sapiens_ |60 |
| Chinese Tussah Moth | _Antheraea pernyi_ |70 |
| Dog | _Canis lupus familiaris_ |80 |
| Common Treeshrew | _Tupaia glis_ |90 |
|Common Starling| _Sturnus vulgaris_ |100 |
| Golden-Mantled Ground Squirrel| _Spermophilus lateralis_ |120 |
| Tsetse Fly | _Glossina morsitans_ |145 |
| Honey Bee | _Apis mellifera_ |200 |

the CFF values for these particular animals were taken from a Google Sheet prepared by Jason Schukraft from the article [_Does Critical-Flicker Fusion Frequency Track The Subjective Experience of Time_](https://static1.squarespace.com/static/6035868111c9bd46c176042b/t/60c377be55c0e507bec8934b/1623422910703/Critical%2BFlicker-Fusion%2BReport%2B__%2BRethink%2BPriorities.pdf), which the values were taken from the academic journal [_Potential Biological and Ecological Effects of Flickering Artificial Light_](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0098631) by Richard Inger.

**i will be updating the list of animals in the following updates!**

## CONTROLS QUICK GUIDE
* E1 change species 
* E2 volume
* E3 fine tune
* K1 + K2 toggle recording
* K1 + K3 clear recording buffer
* K2 start/stop
* K3 reverse

## LOOPER AND SAMPLE PLAYER
perception script can be used both as a _instrument looper_ and _sample player_. technically you can use them both at the same time, however I find it more usefull to go either the recording or sample playback route. 

### looper
**start recording** your audio by holding K1 and pressing K2. this will toggle recording state and you will be able to see it by observing the symbol at the bottom of the screen.

* [...] means softcut is playing
* [REC] means softcut is recording

currently the loop is set to 6 seconds, however you can change that by visiting the [PARAMS](#perception-params)

**clear** the recording by holding K1 and pressing K3

### sample player
by visiting the PARAMS menu you can easily load your samples via norns's own disk and use it to play into the buffer

## PLAYBACK CONTROL
by default you start as human, however by moving E1 you can experience the world of animals

moving the encoder will change the main gui and tell you how you are experiencing time through the selected species. you can observe this by seeing the CFF value.

_moving clockwise shall slow down your track, as you are moving towards animals with highter CFF values, thus experiencing the world in a much slower pace. by moving E1 counter-clockwise you are speeding up the sample, as you are moving towards animals with lower CFF values, experiencing the world in a much more hectic manner_

* moving E2 will change the volume of your recorded material
* moving E3, you can fine tune your sample within the perception of species. this is to help you overdubb certain elements in key, if you overdubb it through the eyes of different species.
* pressing K2 will toggle play/stop
* pressing K3 will flip the buffer direction

## PARAMS
by visiting PARAMS, you can change the behavior of the **recording** buffer or **load samples**, however you can also activate some other interesting parameters

### hearing range
in order to fully immerse into the perception of animals, you can also activate their `hearing range` by activating the bandpass filter. by activating, each animal will have a certain bandpass filter based on it's species hearing range. some of these are more speculative, however most have been taken from studies and articles. 

### chaos playground
you can also automate certain elements of the script by entering the chaos playground

`skin walker` shapeshift through different animals by summoning a skinwalker, by repeling it you will stay on the selected species

`bat physics` activate random panning

`time machine` activate moving forwards and backwards in time

all of these have their own intervals, which you can use to make some wacky results

## CREDITS
* cff values were taken from Inger's journal [_Potential Biological and Ecological Effects of Flickering Artificial Light_](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0098631)
* a huge thanks goes to [@sonocircuit](https://github.com/sonocircuit) for testing and giving feedback
* a big thank you to the support on lines community and sleep discord server

## REFERENCES
* Inger, R. [_Potential Biological and Ecological Effects of Flickering Artificial Light_](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0098631)
* Schukraft, J. [_Does Critical-Flicker Fusion Frequency Track The Subjective Experience of Time_](https://static1.squarespace.com/static/6035868111c9bd46c176042b/t/60c377be55c0e507bec8934b/1623422910703/Critical%2BFlicker-Fusion%2BReport%2B__%2BRethink%2BPriorities.pdf)
* Xie, L., Wang, M. [_The characterization of auditory brainstem response (ABR) waveforms: A study in tree shrews (Tupaia belangeri)_](https://www.sciencedirect.com/science/article/pii/S1672293018300096)
* E. Bostrom, J. [_Ultra-Rapid Vision in Birds_](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0151099)
* Carlile S., Pettigrew A. G. [_Auditory responses in the torus semicircularis of the cane toad, Bufo marinus. II. Single unit studies_](https://pubmed.ncbi.nlm.nih.gov/6148757/)
* Healey, K. [_Metabolic rate and body size are linked with perception of temporal information_](https://www.sciencedirect.com/science/article/pii/S0003347213003060?via%3Dihub)
* Fink, M. [_Stimulus-dependent processing of temporal order_](https://www.sciencedirect.com/science/article/abs/pii/S0376635705002627?via%3Dihub)
* RR Fay. 1988. Hearing in Vertebrates: a Psychophysics Databook. Hill-Fay Associates, Winnetka IL.
* D Warfield. 1973. The study of hearing in animals. In: W Gay, ed., Methods of Animal Experimentation, IV. Academic Press, London, pp 43-143.
* RR Fay & AN Popper, eds. 1994. Comparative Hearing: Mammals. Springer Handbook of Auditory Research Series. Springer-Verlag, NY.
* CD West. 1985. The relationship of the spiral turns of the cochela and the length of the basilar membrane to the range of audible frequencies in ground dwelling mammals. Journal of the Acoustic Society of America 77:1091-1101.
* EA Lipman & JR Grassi. 1942. Comparative auditory sensitivity of man and dog. Amer J Psychol 55:84-89.
* HE Heffner. 1983. Hearing in large and small dogs: Absolute thresholds and size of the tympanic membrane. Behav Neurosci 97:310-318.
