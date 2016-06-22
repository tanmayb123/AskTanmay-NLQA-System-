xcodebuild -project TanmayQA.xcodeproj
cp TanmayQA_CAG/ngrammine.py build/Release/ngrammine.py
cp -r TanmayQA_CAG/topia build/Release/topia
cd TanmayQA_NER_FNS
mkdir tmpDependencies
(cd tmpDependencies; jar -xf ../gson-2.3.1.jar)
(cd tmpDependencies; jar -xf ../okhttp-2.7.4.jar)
(cd tmpDependencies; jar -xf ../okio-1.4.0.jar)
(cd tmpDependencies; jar -xf ../watson-developer-cloud-2.9.5.jar)
jar -cvf combined.jar -C tmpDependencies .
javac -cp combined.jar NER_FNS.java
cp *.class ../build/Release/
cp combined.jar ../build/Release/
rm -rf tmpDependencies
rm *.class
cd ..
