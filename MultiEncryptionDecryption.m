disp('Welcome to the Multi-Encryption/Decrytion Program.');

%Prompt user input for plaintext
plainText = input("Enter the plaintext: ", "s");
plainText = upper(plainText);

%remove whitespace 
numArrayplainText = double(plainText);
plainTextNoSpace = '';

sizePlainText = strlength(plainText);

for i=1:sizePlainText
    if numArrayplainText(i) ~= 32   %[whitespace equal to 32 in ASCII value]
        plainTextNoSpace(end+1) = numArrayplainText(i);
    end
end

%Length of the plainText
sizePlainText = strlength(plainTextNoSpace);


% [A == 65 & Z == 90] in ASCII Table
numASCII = 65; 

%create Char variable from 'ABC....XYZ'
charAlpha = 'A':'Z';

%(1)SHIFT CIPHER
%Converting letters in the plaintext ASCII value from 65-90 to 0-25
processTextShift = plainTextNoSpace - numASCII; 

%Shift letters by the Key
keyShift = sizePlainText;
processTextShift = processTextShift + keyShift;

%applying modulus to maintain number between 0-25
processTextShift = mod(processTextShift, 26);  

%Converting from 0-25 to 65-90 in ASCII value
cipherTextShift = char(processTextShift + numASCII);
cipherTextShift;

%(2) MONO-ALPHABETIC CIPHER

%Concatenate two variale, then remove duplicate values 
monoKey = strcat(plainText, charAlpha);    
uniqueMonoKey = unique(monoKey, 'stable');

 %Create empty string array with length of 26(Alphabet Size)
stringArrayAlpha = strings(26);    
stringArrayUniqueMonoKey = strings(26);

%iterating through each letter in the char variable into string array
for i = 1:26
    stringArrayAlpha(i) = charAlpha(i);
    stringArrayUniqueMonoKey(i) = uniqueMonoKey(i);
end

%mapping each letter in the alphabet with the corresponding key
dictionaryMappingMono = dictionary(stringArrayAlpha, stringArrayUniqueMonoKey);


cipherTextMono = "";    %emptry string
for i=1:sizePlainText
    %iterate through (1) each letter in the plaintext, 
    %                (2) apply mapping, (3) save in ciphertext variable          
    cipherTextMono = strcat(cipherTextMono, dictionaryMappingMono(cipherTextShift(i))); 
end

cipherTextMono;

%(3) HILL CIPHER
%Example: https://crypto.interactive-maths.com/hill-cipher.html
plainTextHill = char(cipherTextMono);

keyMatrix = [7, 8; 11, 11];


%If plaintext size is odd, append 'X' to make it even
if rem(sizePlainText,2) == 1  
    plainTextHill = [plainTextHill 'X'];
    sizePlainText = strlength(plainTextHill);
end

plainTextHill;
processTextHill = plainTextHill - numASCII;


%create 1x2 matrix
tempNum = zeros(1,2);

%HillCipher Algorithmn
i=1;
while i < sizePlainText
    
    %save the two letter in the plaintext
    tempNum(1) = processTextHill(i);
    tempNum(2) = processTextHill(i+1);
    
    %perform matrix operation
    tempNum = tempNum*keyMatrix;

    %save the two letter after operation
    processTextHill(i) = tempNum(1);
    processTextHill(i+1) = tempNum(2);
    i = i + 2;
end

processTextHill = mod(processTextHill, 26);  
cipherTextHill = char(processTextHill + numASCII);
cipherTextHill;

% (4) OneTimePad Cipher

keyOTP = '';
for i=1:sizePlainText
    temp = randi(26);  %Create random value between 1-26
    keyOTP(end+1) = charAlpha(temp); 
end

processTextOTP = cipherTextHill - numASCII;
keyOTP = keyOTP - numASCII;

cipherTextOTP = char(mod(processTextOTP + keyOTP, 26) + numASCII);
cipherTextOTP;


% (5) Display the plaintext & ciphertext
fprintf("\n\nPlain-Text: %s\n", plainTextNoSpace);
fprintf("CyperText After Shift Cipher: %s\n", cipherTextShift);
fprintf("CyperText After Mono-Alphabetic Cipher: %s\n", cipherTextMono);
fprintf("CyperText After Hill Cipher: %s\n", cipherTextHill);
fprintf("CyperText After OneTimePad Cipher: %s\n", cipherTextOTP);


%REVERSE ENGINEER THE CIPHERTEXT
rCipherText = '';

% (6) Reverse OneTimePad Cipher
rCipherText = cipherTextOTP;

rProcessTextOTP = cipherTextOTP - numASCII;

rPlainTextOTP = char(mod(rProcessTextOTP - keyOTP, 26) + numASCII);

% (7) Reverse Hill Cipher

processTextHill = rPlainTextOTP - numASCII;

%create 1x2 matrix
tempNum = zeros(1,2);

keyMatrixInverse = [25 22; 1 23];
%HillCipher Algorithmn
i=1;
while i < sizePlainText
    
    %save the two letter in the plaintext
    tempNum(1) = processTextHill(i);
    tempNum(2) = processTextHill(i+1);
    
    %perform matrix operation
    tempNum = tempNum*keyMatrixInverse;

    %save the two letter after operation
    processTextHill(i) = tempNum(1);
    processTextHill(i+1) = tempNum(2);
    i = i + 2;
end

processTextHill = mod(processTextHill, 26);  
rPlainTextHill = char(processTextHill + numASCII);

rPlainTextHill;

%(8) Reverse Mono-Alphabetic Cipher
rProcessMono = rPlainTextHill;

%mapping each letter in the alphabet with the corresponding key
rDictionaryMappingMono = dictionary(stringArrayUniqueMonoKey, stringArrayAlpha); 


rPlainTextMono = "";    %emptry string
for i=1:sizePlainText
    %iterate through (1) each letter in the plaintext, 
    %                (2) apply mapping, (3) save in ciphertext variable          
    rPlainTextMono = strcat(rPlainTextMono, rDictionaryMappingMono(rProcessMono(i))); 
end

rPlainTextMono;

%(9)SHIFT CIPHER
%Converting letters in the plaintext ASCII value from 65-90 to 0-25
rProcessTextShift = char(rPlainTextMono) - numASCII;

%Shift letters by the Key
rProcessTextShift = rProcessTextShift - keyShift;

%applying modulus to maintain number between 0-25
rProcessTextShift = mod(rProcessTextShift, 26);

%Converting from 0-25 to 65-90 in ASCII value
rPlainText = char(rProcessTextShift + numASCII);
rPlainText;


% (10) Display the plaintext & ciphertext
fprintf("\n\nCipher-Text: %s\n", rCipherText);
fprintf("CyperText After OneTimePad Decipher: %s\n", rPlainTextOTP);
fprintf("CyperText After Hill Decipher: %s\n", rPlainTextHill);
fprintf("CyperText After Mono-Alphabetic Decipher: %s\n", rPlainTextMono);
fprintf("CyperText After Shift Decipher: %s\n", rPlainText);
