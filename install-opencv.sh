curl -L https://sourceforge.net/projects/memoji-opencv/files/src/opencv2.framework.zip/download
unzip -q opencv2_framework.zip
rm opencv2_framework.zip


curl -L https://sourceforge.net/projects/memoji-opencv/files/src/face-model.zip/download --output face-model.scn
mv face-model.scn Memoji-OpenCV/SceneKit Asset Catalog.scnassets
