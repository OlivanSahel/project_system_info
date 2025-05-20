


def reg_to_add(reg,dec=0):#transforme le registe en nombre binaire sur 8 bit
    if reg[0]== "R":
        if reg[-1] == ",":
            num = int(reg[1:-1])+dec
        else:
            num = int(reg[1:])+dec
        binaire = bin(num)[2:]  # Convertit le nombre en binaire
        binaire = binaire.zfill(8)  # Ajoute des zéros à gauche pour obtenir 8 bits
        return binaire
    else:
        return reg
def val_to_bin(val):#transforme la valeur en nombre binaire sur 8 bit
    num = int(val)
    binaire = bin(num)[2:]  # Convertit le nombre en binaire
    binaire = binaire.zfill(8)  # Ajoute des zéros à gauche pour obtenir 8 bits
    return binaire

def inst_to_bin(inst):
    if inst=="ADD":
        return "00000001"
    elif inst=="MUL":
        return "00000010"
    elif inst=="SOU":
        return "00000011"
    elif inst=="DIV":
        return "00000100"
    elif inst=="COP":
        return "00000101"
    elif inst=="AFC":
        return "00000110"
    elif inst=="LOAD":
        return "00000111"
    elif inst=="STORE":
        return "00001000"
    else:
        return "00000000"

def num_reg(reg):
    if reg[0] == "R":
        if reg[-1] == ",":
            num = int(reg[1:-1])
        else:
            num = int(reg[1:])
    else:
        num = int(reg,2)
    return num

filename = "output.asm"  # Replace with your file name
longue_liste = []
liste = []
with open(filename, "r") as file:
    for line in file:
        words = line.split()
        longue_liste.append(words)

i=0

while i < len(longue_liste):  
    if longue_liste[i][0] == "MOV":
        if "R" not in longue_liste[i][2]:#on a une affectation
            liste=liste+[["AFC", longue_liste[i][1], longue_liste[i][2]]]
            liste=liste+[["STORE",longue_liste[i][1],reg_to_add(longue_liste[i][1])]]
        else:#on a une copie
            liste=liste+[["LOAD",longue_liste[i][2],reg_to_add(longue_liste[i][2])]]
            liste=liste+[["COP" , longue_liste[i][1] , longue_liste[i][2]]]
            liste=liste+[["STORE",longue_liste[i][1],reg_to_add(longue_liste[i][1])]]
    elif longue_liste[i][0]=="RET":
        liste=liste+["COP R0 ",longue_liste[i][1]]
    elif longue_liste[i][0]=="ADD" or longue_liste[i][0]=="MUL" or longue_liste[i][0]=="DIV":
        liste=liste+[["LOAD",longue_liste[i][2],reg_to_add(longue_liste[i][2])]]
        liste=liste+[["LOAD",longue_liste[i][3],reg_to_add(longue_liste[i][3])]]
        liste=liste+[longue_liste[i]]
        liste=liste+[["STORE",longue_liste[i][1],reg_to_add(longue_liste[i][1])]]
    elif longue_liste[i][0]=="SUB":
        liste=liste+[["LOAD",longue_liste[i][2],reg_to_add(longue_liste[i][2])]]
        liste=liste+[["LOAD",longue_liste[i][3],reg_to_add(longue_liste[i][3])]]
        liste=liste+[["SOU",longue_liste[i][1],longue_liste[i][2],longue_liste[i][3]]]
        liste=liste+[["STORE",longue_liste[i][1],reg_to_add(longue_liste[i][1])]]
    #reste a gerer le load et le store

    else:
        liste=liste+[longue_liste[i]]
    i+=1

#verifier que les registres depassent pas 13, si c'est le cas il faut utiliser la memoire
i=0
liste2=[]
while i < len(liste):
    if "AFC" in liste[i][0]:#AFC R89 valeur
        
        if num_reg(liste[i][1]) >= 15:
            add_origine = reg_to_add(liste[i][1])
            liste2=liste2+["00001101000010000000110100000000"]#STORE @13 R13
            liste2=liste2+["0000110100000110" + str(val_to_bin(liste[i][2])+"00000000")]#AFC R13 valeur
            liste2=liste2+[str(add_origine)+ "00001000" + "0000110100000000"]#STORE @89 R13
            liste2=liste2+["00001101000001110000110100000000"]#LOAD R13 @13
        else:
            liste2=liste2+[str(reg_to_add(liste[i][1]))+"00000110" + str(val_to_bin(liste[i][2]))+"00000000"]
    elif "COP" in liste[i][0]:#COP R89 R90
        if num_reg(liste[i][1]) >= 15 or num_reg(liste[i][2]) >= 15:
            add_origine = reg_to_add(liste[i][1])
            liste2=liste2+["00001101000010000000110100000000"]#STORE @13 R13
            liste2=liste2+["00001110000010000000111000000000"]#STORE @14 R14
            liste2=liste2+[str(reg_to_add(liste[i][1])) +"00000111" + "0000110100000000"]#load
            liste2=liste2+[str(reg_to_add(liste[i][2])) +"00000111" + "0000111000000000"]#load
            liste2=liste2+["00001101000001010000111000000000"]#cop
            liste2=liste2+[str(add_origine)+"000010000000110100000000"]#STORE @89 R13
            liste2=liste2+["00001110000001110000111000000000"]#load
            liste2=liste2+["00001101000001110000110100000000"]#load
        else:
            
            liste2=liste2+[reg_to_add(liste[i][1])+"00000101" + reg_to_add(liste[i][2])+"00000000"]
    elif "ADD" in liste[i][0] or "SOU" in liste[i][0] or "MUL" in liste[i][0] or "DIV" in liste[i][0]:#ADD R89 R90 R91
        if num_reg(liste[i][1]) >= 15 or num_reg(liste[i][2]) >= 15 or num_reg(liste[i][3]) >= 15:
            liste2=liste2+["00001101000010000000110100000000"]#STORE @13 R13
            liste2=liste2+["00001110000010000000111000000000"]
            liste2=liste2+["00001111000010000000111100000000"]
            liste2=liste2+[str(reg_to_add(liste[i][1])) +"00000111"  + "0000110100000000"]
            liste2=liste2+[str(reg_to_add(liste[i][2])) +"00000111"  + "0000111000000000"]
            liste2=liste2+[str(reg_to_add(liste[i][3])) +"00000111"  + "0000111100000000"]
            liste2=liste2+["00001101"+str(inst_to_bin(liste[i][0])) +"000011100000111100000000"]
            liste2=liste2+[str(reg_to_add(liste[i][1]))+"00001000" + "0000110100000000"]
            liste2=liste2+["00001101000001110000110100000000"]
            liste2=liste2+["00001110000001110000111000000000"]
            liste2=liste2+["00001111000001110000111100000000"]
        else:
            liste2=liste2+[str(reg_to_add(liste[i][1]))+str(inst_to_bin(liste[i][0])) + str(reg_to_add(liste[i][2])) + str(reg_to_add(liste[i][3]))]
    elif "LOAD" in liste[i][0]:#LOAD R89 @90
        if num_reg(liste[i][1]) >= 15:
            #liste2=liste2+["00000000000000000000000000000000"]
            liste2=liste2+[str(reg_to_add(liste[i][2]))+"000001110000000000000000"]
        else:
            liste2=liste2+[str(reg_to_add(liste[i][2]))+"00000111"+str(reg_to_add(liste[i][1])) +"00000000"]
    elif "STORE" in liste[i][0]:#STORE @89 R90
        if num_reg(liste[i][2]) >= 15:
            #liste2=liste2+["00000000000000000000000000000000"]
            liste2=liste2+[str(reg_to_add(liste[i][1]))+"000010000000000000000000"]
        else:
            liste2=liste2+[str(reg_to_add(liste[i][1]))+"00001000"+str(reg_to_add(liste[i][2])) +"00000000"]

    else:
        print(liste[i],liste[i][0])
        liste2=liste2+["00000000000000000000000000000000"]


        

    i+=1
res=[]
for i in range(len(liste)):
    res2=""
    for j in range(len(liste[i])):
        res2=res2+str(liste[i][j])+" "
    res=res+[res2]

with open("assembleur2.txt", "w") as fichier:
    for element in res:
        fichier.write(element + "\n")


with open("sortie.txt", "w") as fichier:
    for element in liste2:
        fichier.write(element + "\n")

