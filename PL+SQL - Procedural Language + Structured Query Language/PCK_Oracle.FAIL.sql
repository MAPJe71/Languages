/* **************************************************************/
/*                           PACKAGE    Definition                     */
/*        Give name of external procedure/function*/
/* **************************************************************/

CREATE OR REPLACE PACKAGE PCK_ORACKE
IS

	--Global Variables 
	CP_CODE_TRAITEMENT CONSTANT SMX_FRM_BATCH.CODEBATCH%TYPE := 'ORA';
	CP_NOM_JALON_DEB varchar2(15) := ' DEBUT';
	CP_NOM_JALON_FIN varchar2(15) := ' FIN';
	mnNbAnomalies     		TABLE.NBERROR%TYPE;		
	mnPaquetRowBatchNum		number := 10000;					
	msUserSiebel			varchar2(255);						

	/**********			Procédures          				 **********/
	-- Initialise le batch
	PROCEDURE PRC_START_INIT(psParamSetName in varchar2, pnResult out number);

	-- verifie l integrite des enregistrements selectionnes
	PROCEDURE PRC_VERIF(psParamSetName in varchar2, pnResult out number);

		-- Clot le batch
	PROCEDURE PRC_START_CLOT(psParamSetName in varchar2, pnResult out number);


	/**********         Functions         							 **********/
	FUNCTION FCT_READ_PARAM(psParamSetName in varchar2) return BOOLEAN;

END;
/


/* **************************************************************/
/*                           PACKAGE    Body				                     */
/* **************************************************************/

CREATE OR REPLACE PACKAGE BODY PCK_SMX_VEH_ADD
IS

	-- Global Internal Variables
	msEventName varchar2(100);
	msCodeEtape varchar2(30); -- Variable identifiant l'etape

   /***********************************************************************/
   /*                          PROCEDURE                                  					*/
   /***********************************************************************/

PROCEDURE PRC_START_INIT(psParamSetName in varchar2, pnResult out number)
 IS

	lbFlagErreur BOOLEAN;

   BEGIN

	msCodeEtape := 'INIT';
	mnNbAnomalies := 0;

	-- Journalisation du debut du traitement (uniquement etape INIT)
    OTHERPACKAGE.PRC_SMX_STARTBATCH (CP_CODE_TRAITEMENT,'', lbFlagErreur);

	-- Si pas d'erreur, alors appel du prog de traitement
	IF lbFlagErreur = TRUE THEN
		pnResult := -1;
  ELSE
		begin

			lbFlagErreur := FCT_READ_PARAM(psParamSetName);

			DELETE FROM TBL1;
			COMMIT;

		
        	pnResult := 0;

        EXCEPTION
			WHEN OTHERS THEN
				-- Log de l'erreur
				DBMS_OUTPUT.PUT_LINE(to_char(sysdate,'YYYY-MM-dd HH:MM:SS') || ' - ' || OTHERPACKAGE.CP_ANOMALIE_FATAL || ' - PRC_START_INIT - ' || SQLCODE || ' - ' || SQLERRM);
				pnResult := -1;
				return;
		END;  -- exception

	END IF;

	COMMIT;

 END PRC_START_INIT;

   /***********************************************************************/
   /*                          FONCTION                                  					*/
   /***********************************************************************/


 FUNCTION FCT_READ_PARAM(psParamSetName in varchar2) return BOOLEAN
 IS

	lsIsRunning        OTHERPACKAGE.ISRUNNING%TYPE;

   BEGIN

		BEGIN

			-- on interroge la table des batchs afin de savoir si le batch est en cours d execution
			SELECT nvl(ISRUNNING,'N')
			INTO lsIsRunning
			FROM TRACETABLE
			WHERE CODEBATCH = CP_CODE_TRAITEMENT
			AND IDBATCHTRACE = (SELECT max(IDBATCHTRACE)
								FROM OTHERPACKAGE
								WHERE CODEBATCH = CP_CODE_TRAITEMENT);
		EXCEPTION
			WHEN NO_DATA_FOUND THEN
			lsIsRunning := 'N';
		END;

		IF lsIsRunning = 'N' THEN
	 		OTHERPACKAGE.mnNivTrace :=0;
			msEventName := msCodeEtape || ' Batch non initialise';
			OTHERPACKAGE.PRC_SMX_WRITEMSGLOG (CP_CODE_TRAITEMENT,
		                                msEventName);
			return FALSE;
		end if;

	
	 	OTHERPACKAGE.mnNivTrace := OTHERPACKAGE.FCT_SMX_READ_PARAM(CP_CODE_TRAITEMENT,psParamSetName,'NIVTRACE');

		return true;

	Exception
		when others then
	 		OTHERPACKAGE.mnNivTrace :=0;
			msEventName := msCodeEtape || ' Lecture parametres impossible';
			OTHERPACKAGE.PRC_SMX_WRITEMSGLOG (CP_CODE_TRAITEMENT,
		                                msEventName);

		return false;

 END FCT_READ_PARAM;



   /***********************************************************************/
   /*                          PROCEDURE  PRC_VERIF                                 					*/
   /***********************************************************************/


 PROCEDURE PRC_VERIF(psParamSetName in varchar2, pnResult out number)
 IS

	lsErrorLang 	varchar2(20);
	lsErrorLevel 	varchar2(20);
		
	BEGIN

		dbms_output.enable(1000000);
		msCodeEtape := 'PRC_VERIF';

		IF FCT_READ_PARAM(psParamSetName) THEN

			
			msEventName := msCodeEtape || CP_NOM_JALON_DEB;
			OTHERPACKAGE.PRC_SMX_WRITEMSG (CP_CODE_TRAITEMENT,
		                                msEventName);
			
			OTHERPACKAGE.PRC_SMX_READ_ERR_BATCH_RUN (CP_CODE_TRAITEMENT,
		                                mnNbAnomalies);
			BEGIN -- Exception
			
				-- si il existe plusieur LOC dans S_ORG_EXT , prendre l'un deux, par ex le min
				UPDATE TABLE2 SET FIELD = 0;

				COMMIT;
			     pnResult := 0;

						-- Gestion des erreurs techniques et fonctionnelles
			EXCEPTION

		 		WHEN OTHERS THEN
						ROLLBACK;

						-- procedure de tracage des anomalies
						OTHERPACKAGE.PRC_SMX_WRITEERROR(CP_CODE_TRAITEMENT,
		                                  OTHERPACKAGE.CP_ANO_TECH,
		                                  '',
		                                  TO_CHAR(SQLCODE) || ':'|| SQLERRM,
		                                  lsErrorLevel,lsErrorLang);
						mnNbAnomalies := mnNbAnomalies + 1;
						pnResult := -1;

			END;  --- exception



			-- Mise à jour du nombre d'erreur
			OTHERPACKAGE.PRC_SMX_WRITE_ERR_BATCH_RUN (CP_CODE_TRAITEMENT,
		                                mnNbAnomalies);

		ELSE
			-- package non initialisé
			OTHERPACKAGE.PRC_SMX_WRITEMSGLOG(CP_CODE_TRAITEMENT, OTHERPACKAGE.CMS_LIB_PCK_INIT_NOK);
			pnResult := -1;
		END IF;

 END PRC_VERIF;




	/**********************************************************************/
	/*                          PROCEDURE  PRC_START_CLOT                     					*/
	/**********************************************************************/


 PROCEDURE PRC_START_CLOT(psParamSetName in varchar2, pnResult out number)
 IS

	BEGIN
		pnResult := 0;

		IF FCT_READ_PARAM(psParamSetName) THEN
			-- Récupération du nombre d'erreur
			OTHERPACKAGE.PRC_SMX_READ_ERR_BATCH_RUN (CP_CODE_TRAITEMENT,mnNbAnomalies);

			-- Journalisation de la fin de traitement
			OTHERPACKAGE.PRC_SMX_ENDBATCH (CP_CODE_TRAITEMENT,mnNbAnomalies);

		ELSE
			-- package non initialisé
			OTHERPACKAGE.PRC_SMX_WRITEMSGLOG(CP_CODE_TRAITEMENT, OTHERPACKAGE.CMS_LIB_PCK_INIT_NOK);
			pnResult := -1;
		END IF;

 END PRC_START_CLOT;

END;
/
exit;
