CREATE OR REPLACE PACKAGE PA_ZWS_PEDI IS

TYPE ARRAY_ANIMALID IS TABLE OF ANIMAL.IDANIMAL%TYPE INDEX BY VARCHAR2(12);

PROCEDURE ins_animals (pnAnimalID IN NUMBER, pnFlag IN NUMBER);
FUNCTION nInsertPedigree(pnAnimalID IN NUMBER, pnFlag IN NUMBER) RETURN NUMBER;

PROCEDURE set_codierung;

PROCEDURE pedigree_rrtdm(psFilename IN VARCHAR2 DEFAULT 'pedigree_rrtdm.dat'
, pnMandant IN NUMBER DEFAULT 1
, pnExportBlood IN NUMBER DEFAULT 1
, pnExportNameDame IN NUMBER DEFAULT 1
, pnIgnoreOKCode IN NUMBER DEFAULT 0
, pnGenmarker IN NUMBER DEFAULT 0
, pbNewItb IN BOOLEAN DEFAULT TRUE);

FUNCTION aGetPseudotiere RETURN ARRAY_ANIMALID;

FUNCTION datGetDategeburtParent (pnIdAnimal IN NUMBER) RETURN DATE;

/***************************************************************************/
END PA_ZWS_PEDI;
/
