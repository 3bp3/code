/*
  listIteratorInt.c : list Iterator ADT implementation
  Written by z5140430
  Date: ....
*/

#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include "listIteratorInt.h"

typedef struct Node {
        int value;
        struct Node *next;
        struct Node *prev;
        //struct node has three attibutes
} Node;

typedef struct IteratorIntRep {
        Node *head;             //head and current,using to move
        Node *cur;
        int flag;               //to judge whichone it just excuted
} IteratorIntRep;



/*

  Your local functions here, if any....


 */



IteratorInt IteratorIntNew(){
        IteratorIntRep *it = malloc(sizeof(IteratorIntRep));
        assert(it != NULL);
        //create a new IteratorInt,initilize
        it->cur = NULL;
        it->head = NULL;
        it->flag = 0;

        return it;
}

void reset(IteratorInt it){
        it->cur = NULL;
        it->flag = 1;
}


int add(IteratorInt it, int v){

        Node *new_node;
        new_node = malloc(sizeof(struct Node));
        //consider the first element
        if (it->head == NULL){
        it->head = new_node;
        it->cur = new_node;
        new_node->value = v;
        return 1;
        }
        new_node->value = v;
        if (it->cur->next != NULL){
            new_node->next = it->cur->next;
            it->cur->next->prev = new_node;
        }//if insert sth in the middle
        it->cur->next = new_node;
        it->cur->next->prev = it->cur;
        it->cur = new_node;

        return 1;
}


int hasNext(IteratorInt it){
        if(it->cur->next != NULL){
                return 1;
        }
        return 0;
}

int hasPrevious(IteratorInt it){
        if(it->cur->prev != NULL){
                return 1;
        }
        return 0;
}


int *next(IteratorInt it){
        //if reset
        if ((it->flag == 1) && (it->cur == NULL)){
                it->cur = it->head;
                return &(it->head->value);
        }
        if (it->cur != NULL){
                it->cur = it->cur->next;
                it->flag = 2;
                return &(it->cur->value);
        }else{
//if current == NULL,divided to 2 situation:1. next,next   2.other,next
                if(it->flag == 2){
                        return NULL;
                }else{
                        it->cur = it->head;
                        it->flag = 2;
                        return &(it->cur->value);
                }
        }

}

int *previous(IteratorInt it){
        //if reset
        if ((it->flag == 1) && (it->cur == NULL)){
                return NULL;
        }
        if (it->cur != NULL){
                int *tmp;
                tmp = &(it->cur->value);
                it->cur = it->cur->prev;
                it->flag = 3;
                return tmp;
        }else{
                return NULL;
        }


}


int deleteElm(IteratorInt it){

        //delete delete is not allowed
        if(it->flag == 4){
                return 0;
        }
        //when next
        if (it->flag == 2){
                Node *tmp = NULL;
                tmp = it->cur;
                it->cur = it->cur->prev;
        //divided to 2 situations: current == NULL or not
                if (it->cur != NULL){
                        it->cur->next = it->cur->next->next;
                        it->cur->next->prev = it->cur;
                }else{
                        it->head = NULL;
                }
                free(tmp);
                it->flag = 4;
                return 1;
        }
        //when previous
        if (it->flag == 3){
                Node *tmp = NULL;
        //also divided to 2 parts
                if (it->cur == NULL){
                        tmp = it->head;
                        it->head = it->head->next;
                        free(tmp);
                        it->flag = 4;
                        return 1;
                }else{
                        tmp = it->cur->next;
                        it->cur->next = it->cur->next->next;
                        it->cur->next->prev = it->cur;
                        free(tmp);
                        it->flag = 4;
                        return 1;
                }

        }
        return 0;
}


int set(IteratorInt it, int v){
        //current is different between next and previous
        if(it->flag == 2){
                it->cur->value = v;
                return 1;
        }
        if (it->flag == 3){
                it->cur->next->value = v;
                return 1;
        }

        return 0;
}

int *findNext(IteratorInt it, int v){
        Node *tmp;
        tmp = NULL;
        //current point to the element after the value
        while(it->cur != NULL){
                if(it->cur->value == v){
                        tmp = it->cur;
                        it->cur = it->cur->next;
                        return &(tmp->value);
                }else{
                        it->cur = it->cur->next;
                }
        }
        //not find again, return the last point
        if(tmp != NULL){
                it->cur = tmp;
        }
        return NULL;
}

int *findPrevious(IteratorInt it, int v){
        Node *tmp = NULL;
        //current point point to the element before the value
        while(it->cur != NULL){
                if(it->cur->value == v){
                        tmp = it->cur;
                        it->cur = it->cur->prev;
                        return &(tmp->value);
                }else{
                        it->cur = it->cur->prev;
                }
        }
        //same as before
        if(tmp != NULL){
                it->cur = tmp;
        }
        return NULL;
}

void freeIt(IteratorInt it){
        //free each element and it
        assert(it != NULL);
        Node *prev,*cur;
        cur = it->head;
        while(cur != NULL){
                prev = cur;
                cur = cur->next;
                free(prev);
        }
        free(it);
        return;

}