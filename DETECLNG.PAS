{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/CODER/IALIB-TP)
  @abstract(Target: Turbo Pascal 7, Free Pascal 3.2)
}

Unit DETECLNG;

INTERFACE

Type
 LanguageName=(Unknown,French,English);

Function DetectLanguage(Message:String):LanguageName;

IMPLEMENTATION

Uses Strings;

Const
 EnglishList:Array[0..256]of PChar=(
  'a','about','an','and','arise','ask','assembly','available',
  'awake','back','be','bear','beat','became','begin','bend',
  'bet','bid','bind','bite','bleed','blow','both','break','breed',
  'bring','buffer','build','burn','burst','buy','by','can',
  'cast','catch','choose','cling','come','communications',
  'cost','could','creep','cut','deal','device','devices',
  'dig','displayed','dive','do','download','draw','dream',
  'drink','drive','dwell','eat','editor','either','example','exit',
  'fall','feature','feed','feel','few','fight','file','find',
  'flee','fling','fling','fly','folder','following','for',
  'forbid','forget','forgive','format','freeze','from',
  'functions','game','get','give','go','grind','grow',
  'hang','have','he','hear','hello','her','hers','herself','hide',
  'higher','him','himself','his','hit','hold','hurt','I','in','is',
  'it','its','itself','just','keep','kneel','knit','know','lay',
  'lead','leap','learn','leave','lend','let','lie','light','lose',
  'make','me','mean','meet','mine','mistake','move','mow','my',
  'myself','obtained','of','or','our','ours','ourselves','pay',
  'programmers','put','read','replaced','retrieves','returns',
  'rid','ride','ring','rise','run','saw','say','seconds','see',
  'seek','sell','send','set','sew','shake','she','shed','shine',
  'shoot','shoot','should','show','shut','sing','sink','sit',
  'slay','sleep','slide','slit','slit','smell','sow','speak',
  'speed','spell','spend','spill','spin','spit','spoil','spread',
  'spring','stand','statement','steal','steal','stick','stink',
  'strike','string','string','swear','sweat','sweep','swell',
  'swim','swing','take','teach','tear','technology','tell',
  'text','that','the','there','their','theirs','them','themselves',
  'they','think','this','though','throw','to','too','tread',
  'typical','understand','undo','upload','upset','us','values',
  'very','wake','want','was','whatever','wear','weave','weep',
  'welcome','with','win','wind','withdraw','withstand','work',
  'wring','write','you','your','yours','yourself','yourselves'
 );

 FrenchList:Array[0..282]of PChar=(
  '…','a','acc‚l‚rer','accrocher','acheter','affich‚','agenouiller',
  'aller','amener','ans','appareils','apporter','apprendre',
  'assembleur','asseoir','attraper','avec','avoir','au','aussi',
  'balancer','balayer','bƒtir','battre','blesser','boire',
  'bouleverser','bondir','bonjour','briller','briser','broyer',
  'br–ler','cacher','casser','cet','chaine','chaŒne','changer',
  'chanter','chef','chercher','choisir','commencer','combattre',
  'comprendre','conduire','connaitre','couch‚','coudre','couper',
  'courber','courir','co–ter','cracher','cramponner','creuser',
  'crever','de','d‚barrasser','debout','d‚cennie','d‚chirer',
  'd‚faire','demander','d‚penser','d‚placez','d‚rober','depuis',
  'deux','devenir','dire','disponible','doit','donner','dormir',
  'dossier','‚clairer','‚clater','‚crire','‚diteur','‚lever','elle',
  'elles','en','enfoncer','enrouler','enseigner','entendre','envoler',
  'envoyer','‚peler','est','et','‚tat','‚teindre','‚tendre','‚veiller',
  'ˆtre','eux','fabriquer','faire','fendre','fermer','ficele',
  'fichier','fixer','fonctionnalit‚','fonctionner','format',
  'frapper','fuir','gagner','garder','geler','gˆter','glisser',
  'gonfler','grandir','il','ils','inciser','instruction','interdire',
  'je','jeter','jeu','jurer','la','laisser','lancer','langage',
  'le','l‚ger','les','leurs','lever','lire','lui','mais','manger',
  'marcher','mˆme','mener','mettre','miens','modifier','moi','mon',
  'monter','montrer','mordre','nager','nos','notre','n“tre','notres',
  'nourir','nous','obtenir','obtenues','offrir','ordinateur','ou',
  'oublier','par','pardonner','parier','parler','partager','partir',
  'payer','pendant','pendre','penser','perdre','p‚riph‚rique',
  'p‚riph‚riques','permet','peu','peur','peut','placer','pleurer',
  'plier','plonger','plus','porter','ports','poser','pour','pouvoir',
  'prendre','prenez','prˆter','programmeur','programmeurs','propos',
  'protocole','puer','que','raconter','ramper','r‚cupŠre','r‚dacteur',
  'relever','relier','rencontrer','renverser','renvoie','r‚pandre',
  'replac‚','r‚sider','r‚sister','ressentir','retirer','r‚veiller',
  'rˆver','sa','saigner','saisir','sauter','savoir','scier','se',
  'secondes','secouer','semer','sentir','s‚rie','sienne','signifier',
  'soit','son','sonner','sortie','souffler','sauvegardez','siens',
  'simplement','suer','suivantes','sup‚rieur','sur','surgir','ta',
  'tampon','technologie','t‚l‚chargement','t‚l‚versement','tenir',
  'texte','tiens','tirer','tisser','tordre','tomber','ton','tondre',
  'tournoyer','traiter','transpirer','travailler','trŠs','tricoter',
  'tromper','trouver','tu','tuer','typique','un','une','valeurs',
  'vendre','venir','voir','voler','vos','votre','votres','v“tre',
  'vouloir','vous'
 );

Var
 FrenchWord,EnglishWord:LongInt;
 BeginWord,I,J:Integer;
 FoundMultiWord:Boolean;
 SourceFile:Text;
 FileName,CurrLine,CurrWord:String;

Function StrToUpper(S:String):String;
Var
 I:Byte;
Begin
 For I:=1 to Length(S)do Begin
  If S[I] in['a'..'z']Then S[I]:=Chr(Ord(S[I])-32);
 End;
 StrToUpper:=S;
End;

Function IsLetter(Chr:Char):Boolean;Begin
 IsLetter:=Chr in ['A'..'Z','a'..'z','‚','ˆ','Š','…','ƒ','“','‡'];
End;

Procedure CompileWord;
Var
 I:Integer;
Begin
 For I:=Low(EnglishList) to High(EnglishList) do Begin
  If StrToUpper(StrPas(EnglishList[I]))=StrToUpper(CurrWord)Then Begin
   Inc(EnglishWord);
   Exit;
  End;
 End;
 For I:=Low(FrenchList) to High(FrenchList) do Begin
  If StrToUpper(StrPas(FrenchList[I]))=StrToUpper(CurrWord)Then Begin
   Inc(FrenchWord);
   Exit;
  End;
 End;
End;

Procedure ParseLineDetectLanguage;Begin
 CurrWord:='';
 BeginWord:=1;
 For I:=1 to Length(CurrLine)do Begin
  If(IsLetter(CurrLine[I]))Then CurrWord:=CurrWord+CurrLine[I]
   Else
  Begin
   CompileWord;
   CurrWord:='';
   BeginWord:=I+1;
  End;
 End;
 CompileWord;
End;

Function DetectLanguage(Message:String):LanguageName;Begin
 DetectLanguage:=Unknown;
 CurrLine:=Message;
 ParseLineDetectLanguage;
 If FrenchWord>EnglishWord Then DetectLanguage:=French Else
 If EnglishWord>0 Then DetectLanguage:=English;
End;

END.