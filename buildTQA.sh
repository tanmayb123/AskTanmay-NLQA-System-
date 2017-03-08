xcodebuild -project TanmayQA.xcodeproj
cp TanmayQA_CAG/ngrammine.py build/Release/ngrammine.py
cp -r TanmayQA_CAG/topia build/Release/topia
cp -r TanmayQA_CAG/zope build/Release/zope
mv build/Release/ ./bin
rm -rf build
