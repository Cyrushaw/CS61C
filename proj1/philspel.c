/*
 * Include the provided hash table library.
 */
#include "hashtable.h"

/*
 * Include the header file.
 */
#include "philspel.h"

/*
 * Standard IO and file routines.
 */
#include <stdio.h>

/*
 * General utility routines (including malloc()).
 */
#include <stdlib.h>

/*
 * Character utility routines.
 */
#include <ctype.h>

/*
 * String utility routines.
 */
#include <string.h>

/*
 * This hash table stores the dictionary.
 */
HashTable *dictionary;

/*
 * The MAIN routine.  You can safely print debugging information
 * to standard error (stderr) as shown and it will be ignored in 
 * the grading process.
 */
int main(int argc, char **argv) {
  if (argc != 2) {
    fprintf(stderr, "Specify a dictionary\n");
    return 0;
  }
  /*
   * Allocate a hash table to store the dictionary.
   */
  fprintf(stderr, "Creating hashtable\n");
  dictionary = createHashTable(2255, &stringHash, &stringEquals);

  fprintf(stderr, "Loading dictionary %s\n", argv[1]);
  readDictionary(argv[1]);
  fprintf(stderr, "Dictionary loaded\n");

  fprintf(stderr, "Processing stdin\n");
  processInput();

  /*
   * The MAIN function in C should always return 0 as a way of telling
   * whatever program invoked this that everything went OK.
   */
  return 0;
}

/*
 * This should hash a string to a bucket index.  Void *s can be safely cast
 * to a char * (null terminated string) and is already done for you here 
 * for convenience.
 */
unsigned int stringHash(void *s) {
  char *string = (char *)s;
  unsigned int index = string[0] - 'A';
  return index;
  // -- TODO --
}

/*
 * This should return a nonzero value if the two strings are identical 
 * (case sensitive comparison) and 0 otherwise.
 */
int stringEquals(void *s1, void *s2) {
  char *string1 = (char *)s1;
  char *string2 = (char *)s2;
  if(string1 == NULL || string2 == NULL){
    return 0;
  }
  //consider that s1 or s2 equals to NULL.@20240308
  int equal = 0;
  if(!strcmp(string1,string2)){
    equal = 1;
  }
  return equal;
  // -- TODO --
}

/*
 * This function should read in every word from the dictionary and
 * store it in the hash table.  You should first open the file specified,
 * then read the words one at a time and insert them into the dictionary.
 * Once the file is read in completely, return.  You will need to allocate
 * (using malloc()) space for each word.  As described in the spec, you
 * can initially assume that no word is longer than 60 characters.  However,
 * for the final 20% of your grade, you cannot assumed that words have a bounded
 * length.  You CANNOT assume that the specified file exists.  If the file does
 * NOT exist, you should print some message to standard error and call exit(1)
 * to cleanly exit the program.
 *
 * Since the format is one word at a time, with new lines in between,
 * you can safely use fscanf() to read in the strings until you want to handle
 * arbitrarily long dictionary chacaters.
 */
void readDictionary(char *dictName) {
  typedef struct node{
    int num;
    char ch;
    struct node *next;
  }node;
  FILE *dic = fopen(dictName,"r");
  node *list = NULL;
  int num = 0;
  if(dic == NULL){
    fprintf(stderr, "Dictionary does not exist\n");
    exit(1);
  }else{
    while(1){
      char ch = fgetc(dic);
      if(feof(dic)){
        break;
      }
      if(ch != '\n'){
        num ++;
        node *newnode = (node*)malloc(sizeof(node));
        newnode->ch = ch;
        newnode->num = num;
        newnode->next = list;
        list = newnode;
      }else{
        char *str = (char*)malloc(sizeof(char)*(num+1));
        str[num] = '\0';
        while(list != NULL){
          node *temp = list;
          list = list->next;
          str[num-1] = temp->ch;
          num --;
          free(temp);
        }
        insertData(dictionary,(void*)str,(void*)str);
        // free(str);
        //this space is used for data, it mustn't be freed.@20240308
      }
    }
  }
  fclose(dic);
  // -- TODO --
}

/*
 * This should process standard input (stdin) and copy it to standard
 * output (stdout) as specified in the spec (e.g., if a standard 
 * dictionary was used and the string "this is a taest of  this-proGram" 
 * was given to stdin, the output to stdout should be 
 * "this is a teast [sic] of  this-proGram").  All words should be checked
 * against the dictionary as they are input, then with all but the first
 * letter converted to lowercase, and finally with all letters converted
 * to lowercase.  Only if all 3 cases are not in the dictionary should it
 * be reported as not found by appending " [sic]" after the error.
 *
 * Since we care about preserving whitespace and pass through all non alphabet
 * characters untouched, scanf() is probably insufficent (since it only considers
 * whitespace as breaking strings), meaning you will probably have
 * to get characters from stdin one at a time.
 *
 * Do note that even under the initial assumption that no word is longer than 60
 * characters, you may still encounter strings of non-alphabetic characters (e.g.,
 * numbers and punctuation) which are longer than 60 characters. Again, for the 
 * final 20% of your grade, you cannot assume words have a bounded length.
 */
void processInput() {
  typedef struct node{
    int num;
    char ch;
    struct node *next;
  }node;
  node *list = NULL;
  int num = 0;
  int flag = 0;
  // -- TODO --
  while(1){
    char ch = getchar();
    //20240308
   
    // if(feof(stdin)){
    //   break;
    // }else{
      if((ch >= 'A' && ch <= 'Z')||(ch >= 'a' && ch <= 'z')){
        flag = 1;
        num ++;
        node *newnode = (node*)malloc(sizeof(node));
        newnode->ch = ch;
        newnode->num = num;
        newnode->next = list;
        list = newnode;
      }else{
        if(flag == 1){
          char *str = (char*)malloc(sizeof(char)*(num+1));
          char *str1 = (char*)malloc(sizeof(char)*(num+1));
          char *str2 = (char*)malloc(sizeof(char)*(num+1));
          str[num] = '\0';
          int num_temp = num;
          while(list != NULL){
            node *temp = list;
            list = list->next;
            str[num-1] = temp->ch;
            num --;
            free(temp);
          }
          str1 = strlwr(str,num_temp);
          strcpy(str2,str1);
          str2[0] = str[0];
          if( stringEquals((void*)str,findData(dictionary,(void*)str))  ||\
              stringEquals((void*)str1,findData(dictionary,(void*)str1)) ||\
              stringEquals((void*)str2,findData(dictionary,(void*)str2)) ){
            printf("%s",str);
          }else{
            printf("%s [sic]",str);
          }
          num = 0;
          free(str);free(str1);free(str2);
          flag = 0;
        }
        if(feof(stdin)){
          break;
        }
        //read end of file, Ctrl+D
        putchar(ch);
      }
    // }
  }
}
char* strlwr(char *str, int num) {
  char *str1 = (char*)malloc(sizeof(str));
  int n = num + 1;
  for(int i = 0;i < n;i ++){
    if(str[i] >= 'A' && str[i] <= 'Z'){
      str1[i] = str[i] + 'a' - 'A';
    }else{
      str1[i] = str[i];
    }
  }
  return str1;
}
