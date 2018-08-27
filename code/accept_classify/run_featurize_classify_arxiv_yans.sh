#!/bin/bash
#set -x

#DATADIR=../../data/iclr_2017
#DATADIR=../../data/arxiv.cs.cl_2007-2017
#data_type=$1
data_type="cl-lg"
#DATADIR=/mnt/sakuradata10-striped/sato/research/yans/PeerRead/data_yans/arxiv.cs.${data_type}_2007-2017
DATADIR=../../data_yans/arxiv.cs.${data_type}_2007-2017/
#DATASETS=("train" "dev" "test")
DATASETS=("train" "dev")
FEATDIR=dataset
MAX_VOCAB=False
ENCODER=w2v
HAND=True



start_time=`date +%s`
for DATASET in "${DATASETS[@]}"
do
	echo "Extracting feautures..." DATASET=$DATASET ENCODER=$ENCODER ALL_VOCAB=$MAX_VOCAB HAND_FEATURE=$HAND
	rm -rf $DATADIR/$DATASET/$FEATDIR
	python featurize.py \
		$DATADIR/$DATASET/reviews/ \
		$DATADIR/$DATASET/parsed_pdfs/ \
		$DATADIR/$DATASET/$FEATDIR \
		$DATADIR/train/$FEATDIR/features_${MAX_VOCAB}_${ENCODER}_${HAND}.dat \
		$DATADIR/train/$FEATDIR/vect_${MAX_VOCAB}_${ENCODER}_${HAND}.pkl \
		$MAX_VOCAB $ENCODER $HAND
	echo
done
echo "run-time: $(expr `date +%s` - $start_time) s"


start_time=`date +%s`
echo "Classifying..." $DATASET $ENCODER $MAX_VOCAB $HAND
python classify.py \
	$DATADIR/train/$FEATDIR/features.svmlite_${MAX_VOCAB}_${ENCODER}_${HAND}.txt \
	$DATADIR/dev/$FEATDIR/features.svmlite_${MAX_VOCAB}_${ENCODER}_${HAND}.txt \
	$DATADIR/train/$FEATDIR/features_${MAX_VOCAB}_${ENCODER}_${HAND}.dat
echo "run-time: $(expr `date +%s` - $start_time) s"


