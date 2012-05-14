--Database
USE muziekdatabase;
GO

/**
*	The function Escape Strign escapes Characters.
*	@String		The string to escape.
*	@return		An escaped string.
**/
CREATE FUNCTION Notillia.foEscapeString(@String NVARCHAR(MAX)) RETURNS NVARCHAR(MAX) AS BEGIN
	RETURN REPLACE(REPLACE(REPLACE(REPLACE(@String, '\', '\\'),
										            '%', '/%'),
										            '_', '\_'),
										            '[', '\{');
END
GO

/**
*	The function prepare location prepares an specific location on the harddisk to save on.
*	@Location	The location to prepare.
*	@Return		The prepared location.
**/
CREATE FUNCTION Notillia.foPrepareLocation(@Location VARCHAR(MAX)) RETURNS VARCHAR(MAX) AS BEGIN
	SET @Location = REPLACE(@Location, '/', '\');
	
	IF ((SUBSTRING(@Location, LEN(@Location), 1)) != '\') BEGIN
		SET @Location += '\';		
	END
	
	RETURN @Location
END
GO

/**
*	The function prepareCMDContent prepares the content of a cmd statement. By escaping > and < values.
*	@Content	The string to escape.
*	@Return		The escaped string.
*/
CREATE FUNCTION Notillia.foPrepareCMDContent(@Content NVARCHAR(MAX)) RETURNS NVARCHAR(MAX) AS BEGIN
	SET @Content = REPLACE(@Content,'<','^<');
	SET @Content = REPLACE(@Content,'>','^>');
	RETURN @Content;
END
GO