
package fluidity.backends;

import fluidity.input.Key;
import fluidity.input.KeyboardKeys;

import lime.ui.KeyCode;

class LimeInput extends Input
{

    public function new()
    {
        super();
    }

    public function limeOnKeyDown(keyCode:KeyCode)
    {
        onKeyDown(getKeyFromCode(keyCode));
    }

    public function limeOnKeyUp(keyCode:KeyCode)
    {
        onKeyUp(getKeyFromCode(keyCode));
    }

    public function getKeyFromCode(keyCode:KeyCode)
    {
        return switch(keyCode)
        {
            case BACKSPACE: KeyboardKeys.BACKSPACE;
            case TAB: KeyboardKeys.TAB;
            case RETURN: KeyboardKeys.ENTER;
            case ESCAPE: KeyboardKeys.ESCAPE;
            case SPACE: KeyboardKeys.SPACE;
            case EXCLAMATION: KeyboardKeys.NUMBER_0;
            case QUOTE: KeyboardKeys.QUOTE;
            case HASH: KeyboardKeys.NUMBER_3;
            case DOLLAR: KeyboardKeys.NUMBER_4;
            case PERCENT: KeyboardKeys.NUMBER_5;
            case AMPERSAND: KeyboardKeys.NUMBER_7;
            case SINGLE_QUOTE: KeyboardKeys.QUOTE;
            case LEFT_PARENTHESIS: KeyboardKeys.NUMBER_9;
            case RIGHT_PARENTHESIS: KeyboardKeys.NUMBER_0;
            case ASTERISK: KeyboardKeys.NUMBER_8;
            case PLUS: KeyboardKeys.EQUAL;
            case COMMA: KeyboardKeys.COMMA;
            case MINUS: KeyboardKeys.MINUS;
            case PERIOD: KeyboardKeys.PERIOD;
            case SLASH: KeyboardKeys.SLASH;
            case NUMBER_0: KeyboardKeys.NUMBER_0;
            case NUMBER_1: KeyboardKeys.NUMBER_1;
            case NUMBER_2: KeyboardKeys.NUMBER_2;
            case NUMBER_3: KeyboardKeys.NUMBER_3;
            case NUMBER_4: KeyboardKeys.NUMBER_4;
            case NUMBER_5: KeyboardKeys.NUMBER_5;
            case NUMBER_6: KeyboardKeys.NUMBER_6;
            case NUMBER_7: KeyboardKeys.NUMBER_7;
            case NUMBER_8: KeyboardKeys.NUMBER_8;
            case NUMBER_9: KeyboardKeys.NUMBER_9;
            case COLON: KeyboardKeys.SEMICOLON;
            case SEMICOLON: KeyboardKeys.SEMICOLON;
            case LESS_THAN: KeyboardKeys.COMMA;
            case EQUALS: KeyboardKeys.EQUAL;
            case GREATER_THAN: KeyboardKeys.PERIOD;
            case QUESTION: KeyboardKeys.SLASH;
            case AT: KeyboardKeys.NUMBER_2;
            case LEFT_BRACKET: KeyboardKeys.LEFTBRACKET;
            case BACKSLASH: KeyboardKeys.BACKSLASH;
            case RIGHT_BRACKET: KeyboardKeys.RIGHTBRACKET;
            case CARET: KeyboardKeys.BACKSLASH;
            case UNDERSCORE: KeyboardKeys.MINUS;
            case GRAVE: KeyboardKeys.BACKQUOTE;
            case A: KeyboardKeys.A;
            case B: KeyboardKeys.B;
            case C: KeyboardKeys.C;
            case D: KeyboardKeys.D;
            case E: KeyboardKeys.E;
            case F: KeyboardKeys.F;
            case G: KeyboardKeys.G;
            case H: KeyboardKeys.H;
            case I: KeyboardKeys.I;
            case J: KeyboardKeys.J;
            case K: KeyboardKeys.K;
            case L: KeyboardKeys.L;
            case M: KeyboardKeys.M;
            case N: KeyboardKeys.N;
            case O: KeyboardKeys.O;
            case P: KeyboardKeys.P;
            case Q: KeyboardKeys.Q;
            case R: KeyboardKeys.R;
            case S: KeyboardKeys.S;
            case T: KeyboardKeys.T;
            case U: KeyboardKeys.U;
            case V: KeyboardKeys.V;
            case W: KeyboardKeys.W;
            case X: KeyboardKeys.X;
            case Y: KeyboardKeys.Y;
            case Z: KeyboardKeys.Z;
            case DELETE: KeyboardKeys.DELETE;
            case CAPS_LOCK: KeyboardKeys.CAPS_LOCK;
            case F1: KeyboardKeys.F1;
            case F2: KeyboardKeys.F2;
            case F3: KeyboardKeys.F3;
            case F4: KeyboardKeys.F4;
            case F5: KeyboardKeys.F5;
            case F6: KeyboardKeys.F6;
            case F7: KeyboardKeys.F7;
            case F8: KeyboardKeys.F8;
            case F9: KeyboardKeys.F9;
            case F10: KeyboardKeys.F10;
            case F11: KeyboardKeys.F11;
            case F12: KeyboardKeys.F12;
            case INSERT: KeyboardKeys.INSERT;
            case HOME: KeyboardKeys.HOME;
            case PAGE_UP: KeyboardKeys.PAGE_UP;
            case END: KeyboardKeys.END;
            case PAGE_DOWN: KeyboardKeys.PAGE_DOWN;
            case RIGHT: KeyboardKeys.RIGHT;
            case LEFT: KeyboardKeys.LEFT;
            case DOWN: KeyboardKeys.DOWN;
            case UP: KeyboardKeys.UP;
            case NUM_LOCK: KeyboardKeys.NUMLOCK;
            case NUMPAD_DIVIDE: KeyboardKeys.NUMPAD_DIVIDE;
            case NUMPAD_MULTIPLY: KeyboardKeys.NUMPAD_MULTIPLY;
            case NUMPAD_MINUS: KeyboardKeys.NUMPAD_SUBTRACT;
            case NUMPAD_PLUS: KeyboardKeys.NUMPAD_ADD;
            case NUMPAD_ENTER: KeyboardKeys.NUMPAD_ENTER;
            case NUMPAD_1: KeyboardKeys.NUMPAD_1;
            case NUMPAD_2: KeyboardKeys.NUMPAD_2;
            case NUMPAD_3: KeyboardKeys.NUMPAD_3;
            case NUMPAD_4: KeyboardKeys.NUMPAD_4;
            case NUMPAD_5: KeyboardKeys.NUMPAD_5;
            case NUMPAD_6: KeyboardKeys.NUMPAD_6;
            case NUMPAD_7: KeyboardKeys.NUMPAD_7;
            case NUMPAD_8: KeyboardKeys.NUMPAD_8;
            case NUMPAD_9: KeyboardKeys.NUMPAD_9;
            case NUMPAD_0: KeyboardKeys.NUMPAD_0;
            case NUMPAD_PERIOD: KeyboardKeys.NUMPAD_DECIMAL;
            // case F13: KeyboardKeys.F13;
            // case F14: KeyboardKeys.F14;
            // case F15: KeyboardKeys.F15;
            case LEFT_CTRL: KeyboardKeys.CONTROL;
            case LEFT_SHIFT: KeyboardKeys.SHIFT;
            case LEFT_ALT: KeyboardKeys.ALTERNATE;
            case RIGHT_CTRL: KeyboardKeys.CONTROL;
            case RIGHT_SHIFT: KeyboardKeys.SHIFT;
            case RIGHT_ALT: KeyboardKeys.ALTERNATE;
            default: KeyboardKeys.F15;
        };
    }
}