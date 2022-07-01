import os

def to_int(char):
    try:
        rsp = int(char)
    except ValueError:
        rsp = ord(char)

    return rsp

# KSA algorithm
def key_scheduling_algorithm(key):
	# Initialization of S
	S = [i for i in range(0, 256)]

	j = 0
	for i in range(0, 256):
		# j = (j + S[i] + key[i mod 16]) mod 256
		j = (j + S[i] + to_int(key[i%16])) % 256
		# swap(S[i], S[j])
		S[i], S[j] = S[j], S[i]
		
	return S

# PRGA Algorithm
def encryption(S, plaintext):
    P = [ord(e) for e in plaintext]
    C = []

    i = 0
    j = 0
    for l in range(0, len(P)):
        i = (i + 1) % 256
        j = (j + S[i]) % 256
		# swap(S[i], S[j])
        S[i], S[j] = S[j], S[i]
        
        K = S[(S[i] + S[j]) % 256]
        C.append(P[l] ^ K)
        
    return C, P


if __name__ == "__main__":
    path = "project_930II_21.22_simplified_rc4_dec_module/modelsim/tv/"

    file_name_seed = "seed"
    file_name_plain = "plain"
    file_name_cipher = "cipher"
    ext = ".txt"

    print("PATH: {}\n".format(path))


    ############################################
    # GENERATE CIPHER0 AND PLAIN0 (WITH KEY0)  #
    ############################################

    key0 = "C123456789012345" # 128 bits (16 bytes)
    
    # Write seed
    print("Writing {} in binary\n".format(file_name_seed+"0"+ext))
    with open(path + file_name_seed + "0" + ext, 'w') as f:
        f.write('\n'.join(['{0:08b}'.format(to_int(key0[i])) for i in range(0, len(key0))]))

    # KSA algorithm
    S = key_scheduling_algorithm(key0)
    

    # PRGA algorithm + encryption
    plain = "Ciao mondo!"
    C, P = encryption(S, plain)

    # Write ciphertext
    print("Writing {} in binary".format(file_name_cipher+"0"+ext))
    with open(path + file_name_cipher + "0" + ext, 'w') as f:
        f.write('\n'.join(['{0:08b}'.format(C[i]) for i in range(0, len(C))]))

    # Write plaintext
    print("Writing {} in binary\n".format(file_name_plain+"0"+ext))
    with open(path + file_name_plain + "0" + ext, 'w') as f:
        f.write('\n'.join(['{0:08b}'.format(P[i]) for i in range(0, len(P))]))


    ############################################
    # GENERATE CIPHER1 AND PLAIN1 (WITH KEY0)  #
    ############################################

    # KSA algorithm
    S = key_scheduling_algorithm(key0)

    # PRGA algorithm + encryption
    plain = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."
    plain = (plain.encode("ascii", "ignore")).decode()
    C, P = encryption(S, plain)

    # Write ciphertext
    print("Writing {} in binary".format(file_name_cipher+"1"+ext))
    with open(path + file_name_cipher + "1" + ext, 'w') as f:
        f.write('\n'.join(['{0:08b}'.format(C[i]) for i in range(0, len(C))]))

    # Write plaintext
    print("Writing {} in binary\n".format(file_name_plain+"1"+ext))
    with open(path + file_name_plain + "1" + ext, 'w') as f:
        f.write('\n'.join(['{0:08b}'.format(P[i]) for i in range(0, len(P))]))


    #####################################################
    # GENERATE CIPHER FILE FROM PLAIN FILE (WITH KEY2)  #
    #####################################################

    key2 = "vdQiC&yM9XE5!BUZ"
    counter = 0

    # Write seed
    print("Writing {} in binary".format(file_name_seed+"_file"+ext))
    with open(path + file_name_seed + "_file" + ext, 'w') as f:
        f.write('\n'.join(['{0:08b}'.format(to_int(key2[i])) for i in range(0, len(key2))]))
    
    # KSA algorithm
    S = key_scheduling_algorithm(key2)

    # Remove non-ASCII characters from the plaintext (DON'T USE TOO BIG FILES)
    f1 = open(path + file_name_plain + "_file" + ext, 'r')
    temp = open(path + "temp_file" + ext, 'w')
    for line in f1:
        new_line = (line.encode("ascii", "ignore")).decode()
        temp.write(new_line)

    f1.close()
    temp.close()

    f1 = open(path + file_name_plain + "_file" + ext, 'w')
    temp = open(path + "temp_file" + ext, 'r')
    for line in temp:
        f1.write(line)

    f1.close()
    temp.close()
    os.remove(path + "temp_file" + ext)

    # Decrypt the clean plaintext
    f1 = open(path + file_name_plain + "_file" + ext, 'r')
    f2 = open(path + file_name_cipher + "_file" + ext, 'w')

    i = 0
    j = 0
    for line in f1:
        for c in line:
            i = (i+1) % 256
            j = (j+S[i]) % 256
		    # swap(S[i], S[j])
            S[j], S[i] = S[i], S[j]

            K = S[(S[i] + S[j]) % 256]
            f2.write('{0:08b}'.format(ord(c) ^ K) + " ")
    
            counter += 1

    print("Encrypted plain_file.txt in cipher_file.txt")
    f1.close()
    f2.close()
    print(counter)