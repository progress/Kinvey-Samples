 
 /*------------------------------------------------------------------------
    File        : Properties
    Purpose     : 
    Syntax      : 
    Description : Simple property manager for security featues.
    Author(s)   : davec
    Created     : Mon Apr 08 10:27:32 EDT 2013
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS OpenEdge.Security.Util.Properties: 
    

    DEFINE PRIVATE STATIC VARIABLE debugMsg AS LOGICAL NO-UNDO INITIAL FALSE.

    DEFINE PRIVATE STREAM    m_propStream.

    DEFINE PRIVATE TEMP-TABLE m_properties  NO-UNDO
                                            FIELD propName  AS CHARACTER 
                                            FIELD propValue AS CHARACTER 
                                            INDEX idxName   IS UNIQUE PRIMARY propName.
    
	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
		
	CONSTRUCTOR PUBLIC Properties (  ):
		SUPER ().
		
	END CONSTRUCTOR.

    CONSTRUCTOR PUBLIC Properties ( INPUT p_path AS CHARACTER ):
         SUPER ().

         IF ( ? = p_path OR "" = p_path ) THEN
            UNDO, THROW NEW Progress.Lang.AppError("Invalid properties file path", 1).

         LoadProps(p_path).

    END CONSTRUCTOR.

    DESTRUCTOR PUBLIC Properties ( ):

    END DESTRUCTOR.

    /*------------------------------------------------------------------------------
        Purpose:                                                                        
        Notes:                                                                        
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC CHARACTER GetCharacterProperty( INPUT p_propName AS CHARACTER,
                                                  INPUT p_defValue AS CHARACTER ):

        DEFINE VARIABLE result AS CHARACTER NO-UNDO.

        IF ( ? = p_propName OR "" = p_propName ) THEN
            UNDO, THROW NEW Progress.Lang.AppError("Invalid parameters", 2).

        FIND FIRST m_properties WHERE m_properties.propName = p_propName NO-ERROR. 
        IF ( AVAILABLE m_properties ) THEN
            result = m_properties.propValue.
        ELSE DO:
            IF ( ? = p_defValue  ) THEN
                UNDO, THROW NEW Progress.Lang.AppError("Invalid parameters", 3).
            ELSE 
                 result = p_defValue.
        END.

        RETURN result.


    END METHOD. /*    CHARACTER  */

    /*------------------------------------------------------------------------------
        Purpose:                                                                        
        Notes:                                                                        
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC LOGICAL GetLogicalProperty( INPUT p_propName AS CHARACTER,
                                              INPUT p_defValue AS LOGICAL ):

        DEFINE VARIABLE result      AS LOGICAL INITIAL NO NO-UNDO.
        DEFINE VARIABLE convert     AS LOGICAL INITIAL NO NO-UNDO. 
        DEFINE VARIABLE tmp         AS CHARACTER INITIAL "" NO-UNDO. 

        IF ( ? = p_propName OR "" = p_propName ) THEN
            UNDO, THROW NEW Progress.Lang.AppError("Invalid parameters", 4).

        FIND FIRST m_properties WHERE propName = p_propName NO-ERROR. 
        IF ( AVAILABLE m_properties AND "" <> m_properties.propValue ) THEN
            tmp = LC(m_properties.propValue).

        IF ( "" = tmp ) THEN DO:
            IF ( ? = p_defValue  ) THEN
                UNDO, THROW NEW Progress.Lang.AppError("Invalid parameters",5).
            ELSE 
                result = p_defValue.
        END. ELSE DO:
            IF ( tmp BEGINS "t" OR
                 tmp BEGINS "y" OR
                 tmp BEGINS "1" ) THEN
                result = YES.
        END.

    
        RETURN result.

    END METHOD. /*    CHARACTER  */

    /*------------------------------------------------------------------------------
        Purpose:                                                                        
        Notes:                                                                        
    ------------------------------------------------------------------------------*/

    METHOD PROTECTED LOGICAL LoadProps ( INPUT p_path AS CHARACTER  ):

        DEFINE VARIABLE retVal          AS LOGICAL INITIAL NO NO-UNDO.
        DEFINE VARIABLE propFilePath    AS CHARACTER NO-UNDO. 

        IF debugMsg THEN 
            MESSAGE "Loading properties from file:" p_path.

        propFilePath = SEARCH(p_path).
        IF ( ? <> propFilePath ) THEN DO:

            IF debugMsg THEN 
                MESSAGE "Opening properties file:" propFilePath.
            INPUT STREAM m_propStream FROM VALUE(propFilePath).

            IF debugMsg THEN 
                MESSAGE "Loading properties file:" propFilePath.
            REPEAT :
                CREATE m_properties.
                IMPORT STREAM m_propStream DELIMITER "=" m_properties NO-ERROR.
            END.

            INPUT STREAM m_propStream CLOSE.

            FOR EACH m_properties :
                IF debugMsg THEN 
                    MESSAGE "Loaded property" m_properties.propName "with value:" m_properties.propValue.
            END.
            retVal = TRUE.
        END. ELSE DO:
            IF debugMsg THEN 
                MESSAGE "No properties file to load:" p_path.
        END.

        RETURN retVal.

        CATCH e AS Progress.Lang.Error:
            MESSAGE "Error in properties load: " e:GetMessage(1).
        END CATCH.

        FINALLY:
            INPUT STREAM m_propStream CLOSE.
        END FINALLY.

    END METHOD. /*    LOGICAL INITIAL NO */


END CLASS.