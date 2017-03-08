from topia.termextract import extract
import sys

extractor = extract.TermExtractor()
m = extractor(open(sys.argv[1], "r").read())
finalString = ""
for i in m:
    finalString = finalString + "\n" + i[0] + "---***---TANMAY-QA-BARRIER---***---" + str(i[1])
    print finalString
open(sys.argv[2], "w").write(finalString)
