//
// Created by neo on 2019-08-15.
//

#include "../../pinball.h"

#ifndef PINBALL_TTEXTBOXMESSAGE_H
#define PINBALL_TTEXTBOXMESSAGE_H

/* 97 */
struct TTextBoxMessage;

TTextBoxMessage* __thiscall TTextBoxMessage::TTextBoxMessage(TTextBoxMessage* this, char* a2, float a3);
double __thiscall TTextBoxMessage::TimeLeft(TTextBoxMessage* this);
void __thiscall TTextBoxMessage::Refresh(TTextBoxMessage* this, float); // idb
TTextBoxMessage* __thiscall TTextBoxMessage::destroy(TTextBoxMessage* this, char a2);


#endif //PINBALL_TTEXTBOXMESSAGE_H
