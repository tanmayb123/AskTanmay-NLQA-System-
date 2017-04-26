from topia.termextract import extract
import sys

extractor = extract.TermExtractor()
with open(sys.argv[1], "r") as f:
    m = extractor(f.read())
finalString = ""
for i in m:
    finalString = finalString + "\n" + i[0] + "---***---TANMAY-QA-BARRIER---***---" + str(i[1])
    print finalString
with open(sys.argv[2], "w") as f:
    f.write(finalString)
