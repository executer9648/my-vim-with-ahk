#Include Map.ahk
#Include StateBulb.ahk

class Language {

	static _current := this._GetCurrentLanguageCode()
	static prevLanguge := "English"

	static Current {
		get => this._current
		set {
			switch Type(value) {
				case "String": code := this.LangToCode[value]
				case "Integer": code := value
				default: throw ValueError("Wrong type passed.")
			}
			this._current := code
			this._ChangeLanguage(code)
		}
	}

	static CurrentWord {
		get => this.CodeToLang[this._current]
	}

	static CodeToLang := Map(
		"0x4090409", "English",
		"0xfffffffff03d040d", "Hebrew"
	)

	static LangToCode := this.CodeToLang.Reverse()


	static ToHebrew() {
		this.Current := "Hebrew"
		StateBulb[StateBulb.MaxBulbs - 1].Create()
	}
	static ToEnglish() {
		this.Current := "English"
		StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	}

	static ToHebrewB() {
		StateBulb[StateBulb.MaxBulbs - 1].Create()
	}
	static ToEnglishB() {
		StateBulb[StateBulb.MaxBulbs - 1].Destroy()
	}

	static Toggle() {
		switch this.CurrentWord {
			case "Hebrew": this.ToEnglish()
			case "English": this.ToHebrew()
		}
	}

	static ToggleBulb() {
		StateBulb[StateBulb.MaxBulbs - 1].Toggle()
		if StateBulb[StateBulb.MaxBulbs - 1].GuiExist {
			Language.prevLanguge := "Hebrew"
		}
		else {
			Language.prevLanguge := "English"
		}
	}

	static GetKeyboardLanguage()
	{
		if !ThreadId := DllCall("user32.dll\GetWindowThreadProcessId", "Ptr", WinActive("A"), "UInt", 0, "UInt")
			return false

		if !KBLayout := DllCall("user32.dll\GetKeyboardLayout", "UInt", ThreadId, "UInt")
			return false

		return KBLayout & 0xFFFF
	}

	static _GetCurrentLanguageCode() => "0x" Format("{:x}", dllCall("GetKeyboardLayout", "int", 0))

	static _ChangeLanguage(languageCode) {
		try PostMessage(0x0050, , languageCode, , "A")
	}

}

; if !LangID := GetKeyboardLanguage()
; {
; 	MsgBox "GetKeyboardLayout function failed "
; 	return
; }

; if (LangID = 0x0409)
; 	MsgBox "Language is EN"
; else if (LangID = 0x040D)
; 	MsgBox "Language is HE"
; return
