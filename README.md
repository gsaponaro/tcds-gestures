# tcds-gestures
This repository contains code and material for this paper:

* Giovanni Saponaro, Lorenzo Jamone, Alexandre Bernardino and Giampiero Salvi. Beyond the Self: Using Grounded Affordances to Interpret and Describe Others' Actions. IEEE Transactions on Cognitive and Developmental Systems, 2018 (accepted).

## Description

TBA

## Installation

### Dependencies

* MATLAB
* FullBNT
* [AffordancesAndSpeech](https://github.com/giampierosalvi/AffordancesAndSpeech)

### Linux instructions

Install FullBNT to `~/matlab/toolbox` then patch it with our provided patch, like this:

```
cd tcds-gestures
mkdir ~/matlab
mkdir ~/matlab/toolbox
unzip 3rdparty/FullBNT-1.0.4.zip -d ~/matlab/toolbox
patch ~/matlab/toolbox/FullBNT-1.0.4/HMM/fwdback.m < extern/FullBNT/fwdback.patch
```

Clone [AffordancesAndSpeech](https://github.com/giampierosalvi/AffordancesAndSpeech) to a location that can be found by our file `configurePaths.m`. Currently this can be `~/NOBACKUP` or `~/Documents`. For example:

```
cd ~/Documents
git clone https://github.com/giampierosalvi/AffordancesAndSpeech.git
```

## License

Released under the terms of the GPL v3.0 or later. See the file LICENSE for details.
