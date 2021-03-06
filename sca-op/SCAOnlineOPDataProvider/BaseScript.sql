/****** Object:  Table {databaseOwner}.{objectQualifier}[SCAOfficers]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAOfficers]') AND type in (N'U'))
BEGIN
CREATE TABLE {databaseOwner}.{objectQualifier}[SCAOfficers](
	[SCAOfficerID] [int] IDENTITY(0,1) NOT NULL,
	[ModuleID] [int] NOT NULL,
	[OfficerPosition] [nvarchar](100) NULL,
	[SocietyName] [nvarchar](100) NULL,
	[MundaneName] [nvarchar](100) NULL,
	[Address1] [nvarchar](100) NULL,
	[Address2] [nvarchar](100) NULL,
	[City] [nvarchar](100) NULL,
	[State] [nvarchar](50) NULL,
	[Zip] [nvarchar](50) NULL,
	[Phone1] [nvarchar](50) NULL,
	[Phone2] [nvarchar](50) NULL,
	[EmailAddress] [nvarchar](100) NULL,
	[Notes] [nvarchar](500) NULL,
	[ViewOrder] [int] NULL,
	[IconPath] [nvarchar](100) NULL,
	[PhotoPath] [nvarchar](100) NULL,
	[ArmsPath] [nvarchar](100) NULL,
 CONSTRAINT [PK_SCAOfficers] PRIMARY KEY CLUSTERED 
(
	[SCAOfficerID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table {databaseOwner}.{objectQualifier}[SCAMembership]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAMembership]') AND type in (N'U'))
BEGIN
CREATE TABLE {databaseOwner}.{objectQualifier}[SCAMembership](
	[MembershipNumber] [varchar](50) NOT NULL,
	[Waiver] [char](1) NOT NULL,
	[MembershipType] [char](1) NOT NULL,
	[SCAName] [varchar](100) NULL,
	[ModernName] [varchar](100) NULL,
	[Zipcode] [varchar](50) NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table {databaseOwner}.{objectQualifier}[SCAGroupDesignation]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroupDesignation]') AND type in (N'U'))
BEGIN
CREATE TABLE {databaseOwner}.{objectQualifier}[SCAGroupDesignation](
	[GroupDesignationId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[CeremonialHead] [bit] NOT NULL,
 CONSTRAINT [PK_SCAGroupDesignation] PRIMARY KEY CLUSTERED 
(
	[GroupDesignationId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table {databaseOwner}.{objectQualifier}[SCAAwardedBy]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAwardedBy]') AND type in (N'U'))
BEGIN
CREATE TABLE {databaseOwner}.{objectQualifier}[SCAAwardedBy](
	[AwardedById] [int] IDENTITY(1,1) NOT NULL,
	[AwardedBy] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SCAAwardedBy] PRIMARY KEY CLUSTERED 
(
	[AwardedById] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table {databaseOwner}.{objectQualifier}[SCABranchStatus]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCABranchStatus]') AND type in (N'U'))
BEGIN
CREATE TABLE {databaseOwner}.{objectQualifier}[SCABranchStatus](
	[BranchStatusId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SCABranchStatusId] PRIMARY KEY CLUSTERED 
(
	[BranchStatusId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

/****** Object:  UserDefinedFunction {databaseOwner}.{objectQualifier}[iter_intlist_to_tbl]    Script Date: 06/02/2010 22:32:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[iter_intlist_to_tbl]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION {databaseOwner}.{objectQualifier}[iter_intlist_to_tbl] (@list nvarchar(MAX))
   RETURNS @tbl TABLE (listpos int IDENTITY(1, 1) NOT NULL,
                       number  int NOT NULL) AS
BEGIN
   DECLARE @startpos int,
           @endpos   int,
           @textpos  int,
           @chunklen smallint,
           @str      nvarchar(4000),
           @tmpstr   nvarchar(4000),
           @leftover nvarchar(4000)

   SET @textpos = 1
   SET @leftover = ''''
   WHILE @textpos <= datalength(@list) / 2
   BEGIN
      SET @chunklen = 4000 - datalength(@leftover) / 2
      SET @tmpstr = ltrim(@leftover +
                    substring(@list, @textpos, @chunklen))
      SET @textpos = @textpos + @chunklen

      SET @startpos = 0
      SET @endpos = charindex('' '' COLLATE Slovenian_BIN2, @tmpstr)

      WHILE @endpos > 0
      BEGIN
         SET @str = substring(@tmpstr, @startpos + 1,
                              @endpos - @startpos - 1)
         IF @str <> ''''
            INSERT @tbl (number) VALUES(convert(int, @str))
         SET @startpos = @endpos
         SET @endpos = charindex('' '' COLLATE Slovenian_BIN2,
                                 @tmpstr, @startpos + 1)
      END

      SET @leftover = right(@tmpstr, datalength(@tmpstr) / 2 - @startpos)
   END

   IF ltrim(rtrim(@leftover)) <> ''''
      INSERT @tbl (number) VALUES(convert(int, @leftover))

   RETURN
END' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAOfficers_Update]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAOfficers_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'





CREATE   procedure {databaseOwner}.{objectQualifier}[SCAOfficers_Update]

@SCAOfficerId 	int,
@SocietyName	nvarchar(100),
@MundaneName	nvarchar(100),
@Address1	nvarchar(100),
@Address2	nvarchar(100),
@City		nvarchar(100),
@State		nvarchar(50),
@Zip		nvarchar(50),
@Phone1		nvarchar(50),
@Phone2		nvarchar(50),
@EmailAddress	nvarchar(100),
@Notes		nvarchar(500),
@ViewOrder	int,
@IconPath	nvarchar(100),
@PhotoPath	nvarchar(100),
@ArmsPath 	nvarchar(100),
@OfficerPosition nvarchar(100)
as

update SCAOfficers
Set
SocietyName = @SocietyName,
MundaneName = @MundaneName,
Address1 = @Address1,
Address2 = @Address2,
City = @City,
State = @State,
Zip = @zip,
Phone1 = @Phone1,
Phone2 = @Phone2,
EmailAddress = @EmailAddress,
Notes = @Notes,
ViewOrder = @ViewOrder,
IconPath = @IconPath,
PhotoPath = @PhotoPath,
ArmsPath = @ArmsPath,
OfficerPosition = @OfficerPosition
where  SCAOfficerId = @SCAOfficerId





' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAOfficers_GetList]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAOfficers_GetList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'




CREATE   procedure {databaseOwner}.{objectQualifier}[SCAOfficers_GetList]

@ModuleId int

as

select 
SCAOfficerID,
ModuleID,
SocietyName,
MundaneName,
Address1,
Address2,
City,
State,
Zip,
Phone1,
Phone2,
EmailAddress,
Notes,
ViewOrder,
IconPath,
PhotoPath,
ArmsPath,
OfficerPosition
from SCAOfficers
where  ModuleId = @ModuleId
order by ViewOrder asc


' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAOfficers_Get]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAOfficers_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'





CREATE   procedure {databaseOwner}.{objectQualifier}[SCAOfficers_Get]

@SCAOfficerId   int,
@ModuleId int

as

select 
SCAOfficerID,
ModuleID,
SocietyName,
MundaneName,
Address1,
Address2,
City,
State,
Zip,
Phone1,
Phone2,
EmailAddress,
Notes,
ViewOrder,
IconPath,
PhotoPath,
ArmsPath,
OfficerPosition,
ViewOrder
from SCAOfficers
where  SCAOfficerId = @SCAOfficerId
and    ModuleId = @ModuleId




' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAOfficers_Delete]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAOfficers_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'




CREATE  procedure {databaseOwner}.{objectQualifier}[SCAOfficers_Delete]

@SCAOfficerId int

as

delete
from SCAOfficers
where  SCAOfficerId = @SCAOfficerId





' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAOfficers_Add]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAOfficers_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'




CREATE  procedure {databaseOwner}.{objectQualifier}[SCAOfficers_Add]

@ModuleId 	int,
@SocietyName	nvarchar(100),
@MundaneName	nvarchar(100),
@Address1	nvarchar(100),
@Address2	nvarchar(100),
@City		nvarchar(100),
@State		nvarchar(50),
@Zip		nvarchar(50),
@Phone1		nvarchar(50),
@Phone2		nvarchar(50),
@EmailAddress	nvarchar(100),
@Notes		nvarchar(500),
@ViewOrder	int,
@IconPath	nvarchar(100),
@PhotoPath	nvarchar(100),
@ArmsPath 	nvarchar(100),
@OfficerPosition	nvarchar(100)

as

insert into  SCAOfficers
(
ModuleId,
SocietyName,
MundaneName,
Address1,
Address2,
City,
State,
Zip,
Phone1,
Phone2,
EmailAddress,
Notes,
ViewOrder,
IconPath,
PhotoPath,
ArmsPath,
OfficerPosition
)
values
(
@ModuleId,
@SocietyName,
@MundaneName,
@Address1,
@Address2,
@City,
@State,
@Zip,
@Phone1,
@Phone2,
@EmailAddress,
@Notes,
@ViewOrder,
@IconPath,
@PhotoPath,
@ArmsPath,
@OfficerPosition
)


select SCOPE_IDENTITY()



' 
END
GO

/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCABranchStatusUpdate]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCABranchStatusUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCABranchStatusUpdate]
	@BranchStatusId int, 
	@Name varchar(50) 
AS

UPDATE SCABranchStatus SET
	[Name] = @Name
WHERE
	[BranchStatusId] = @BranchStatusId
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCABranchStatusList]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCABranchStatusList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCABranchStatusList]
AS

SELECT
	[BranchStatusId],
	[Name]
FROM SCABranchStatus
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCABranchStatusGet]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCABranchStatusGet]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCABranchStatusGet]
	@BranchStatusId int
	
AS

SELECT
	[BranchStatusId],
	[Name]
FROM SCABranchStatus
WHERE
	[BranchStatusId] = @BranchStatusId
	
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCABranchStatusDelete]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCABranchStatusDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCABranchStatusDelete]
	@BranchStatusId int
AS

DELETE FROM SCABranchStatus
WHERE
	[BranchStatusId] = @BranchStatusId
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCABranchStatusAdd]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCABranchStatusAdd]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCABranchStatusAdd]
	@Name varchar(50)
AS

INSERT INTO SCABranchStatus (
	[Name]
) VALUES (
	@Name
)

select SCOPE_IDENTITY()
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAGroupDesignationUpdate]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroupDesignationUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAGroupDesignationUpdate]
	@GroupDesignationId int, 
	@Name varchar(50), 
	@CeremonialHead bit 
AS

UPDATE SCAGroupDesignation SET
	[Name] = @Name,
	[CeremonialHead] = @CeremonialHead
WHERE
	[GroupDesignationId] = @GroupDesignationId
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAGroupDesignationList]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroupDesignationList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAGroupDesignationList]
AS

SELECT
	[GroupDesignationId],
	[Name],
	[CeremonialHead]
FROM SCAGroupDesignation
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAGroupDesignationGet]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroupDesignationGet]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAGroupDesignationGet]
	@GroupDesignationId int
	
AS

SELECT
	[GroupDesignationId],
	[Name],
	[CeremonialHead]
FROM SCAGroupDesignation
WHERE
	[GroupDesignationId] = @GroupDesignationId
	
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAGroupDesignationDelete]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroupDesignationDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAGroupDesignationDelete]
	@GroupDesignationId int
AS

DELETE FROM SCAGroupDesignation
WHERE
	[GroupDesignationId] = @GroupDesignationId
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAGroupDesignationAdd]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroupDesignationAdd]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAGroupDesignationAdd]
	@Name varchar(50),
	@CeremonialHead bit
AS

INSERT INTO SCAGroupDesignation (
	[Name],
	[CeremonialHead]
) VALUES (
	@Name,
	@CeremonialHead
)

select SCOPE_IDENTITY()
' 
END
GO
/****** Object:  Table {databaseOwner}.{objectQualifier}[SCAGroups]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroups]') AND type in (N'U'))
BEGIN
CREATE TABLE {databaseOwner}.{objectQualifier}[SCAGroups](
	[GroupId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](300) NOT NULL,
	[Code] [varchar](50) NULL,
	[Location] [varchar](200) NULL,
	[Precedence] [int] NULL,
	[FoundingDate] [datetime] NULL,
	[GroupDesignationId] [int] NULL,
	[Hidden] [bit] NOT NULL,
	[ArmsUrl] [varchar](300) NULL,
	[ArmsBlazon] [nvarchar](4000) NULL,
	[BranchStatusId] [int] NOT NULL,
	[Notes] [text] NULL,
	[SovereignMaleTitle] [varchar](50) NULL,
	[SovereignFemaleTitle] [varchar](50) NULL,
	[ConsortMaleTitle] [varchar](50) NULL,
	[ConsortFemaleTitle] [varchar](50) NULL,
	[ParentGroupId] [int] NULL,
	[SovereignArmsUrl] [varchar](300) NULL,
	[SovereignBlazon] [varchar](300) NULL,
	[ConsortArmsUrl] [varchar](300) NULL,
	[WebSiteUrl] [varchar](300) NULL,
	[InternalUrl] [varchar](300) NULL,
	[ConsortBlazon] [varchar](300) NULL,
	[ReignType] [varchar](50) NULL,
	[RegentMaleTitle] [varchar](50) NULL,
	[RegentFemaleTitle] [varchar](50) NULL,
	[RegentType] [varchar](50) NULL,
 CONSTRAINT [PK_SCAGroups] PRIMARY KEY CLUSTERED 
(
	[GroupId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table {databaseOwner}.{objectQualifier}[SCAPeople]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeople]') AND type in (N'U'))
BEGIN
CREATE TABLE {databaseOwner}.{objectQualifier}[SCAPeople](
	[PeopleId] [int] IDENTITY(1,1) NOT NULL,
	[SCAName] [nvarchar](300) NOT NULL,
	[MundaneName] [varchar](300) NULL,
	[Address1] [nvarchar](100) NULL,
	[Address2] [nvarchar](100) NULL,
	[City] [nvarchar](100) NULL,
	[State] [nvarchar](50) NULL,
	[Zip] [nvarchar](50) NULL,
	[Phone1] [nvarchar](50) NULL,
	[Phone2] [nvarchar](50) NULL,
	[EmailAddress] [nvarchar](100) NULL,
	[PhotoURL] [nvarchar](300) NULL,
	[ArmsURL] [nvarchar](300) NULL,
	[ArmsBlazon] [nvarchar](max) NULL,
	[ShowPicPermission] [bit] NOT NULL,
	[ShowEmailPermission] [bit] NOT NULL,
	[AdminNotes] [varchar](8000) NULL,
	[OfficerNotes] [varchar](1000) NULL,
	[OPNum] [int] NULL,
	[Gender] [char](1) NULL,
	[TitlePrefix] [nvarchar](50) NULL,
	[HonorsSuffix] [nvarchar](50) NULL,
	[Deceased] [bit] NOT NULL,
	[DeceasedWhen] [int] NULL,
	[BranchResidenceId] [int] NULL,
	[HighestAwardName] [nvarchar](200) NULL,
	[HighestAwardPrecedence] [int] NULL,
	[HighestAwardDate] [datetime] NULL,
	[HighestAwardId] [datetime] NULL,
	[CrownId] [int] NULL,
 CONSTRAINT [PK_SCAPeople] PRIMARY KEY CLUSTERED 
(
	[PeopleId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeople]') AND name = N'IDX_BranchResidence_PhotoURL_PeopleId')
CREATE NONCLUSTERED INDEX [IDX_BranchResidence_PhotoURL_PeopleId] ON {databaseOwner}.{objectQualifier}[SCAPeople] 
(
	[BranchResidenceId] ASC,
	[PhotoURL] ASC,
	[PeopleId] ASC
)
INCLUDE ( [ShowEmailPermission],
[ShowPicPermission],
[ArmsBlazon],
[ArmsURL],
[Deceased],
[DeceasedWhen],
[OPNum]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeople]') AND name = N'IDX_OPNum')
CREATE NONCLUSTERED INDEX [IDX_OPNum] ON {databaseOwner}.{objectQualifier}[SCAPeople] 
(
	[OPNum] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table {databaseOwner}.{objectQualifier}[SCAGroupHistory]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroupHistory]') AND type in (N'U'))
BEGIN
CREATE TABLE {databaseOwner}.{objectQualifier}[SCAGroupHistory](
	[GroupHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[FromGroupId] [int] NULL,
	[ToGroupId] [int] NULL,
	[Note] [varchar](4000) NULL,
 CONSTRAINT [PK_SCAGroupHistory] PRIMARY KEY CLUSTERED 
(
	[GroupHistoryId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAGroupsListByGroupsGroup]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroupsListByGroupsGroup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAGroupsListByGroupsGroup]
@filter nvarchar(500)
AS

DECLARE @SQL nvarchar(3500)
IF(@filter=''*'')
SELECT
	SCAGroups.GroupId,
	SCAGroups.Name,
	SCAGroups.Name as GroupName,
	SCAGroups.Code,
	SCAGroups.Location,
	SCAGroups.Precedence,
	SCAGroups.Hidden,
	case when armsFiles.FileName is null then SCAGroups.ArmsURL else armsFiles.Folder + armsFiles.FileName end as ArmsURL,
	case when armsFiles.Width is null then 0 else armsFiles.Width end as ArmsURLWidth,
	case when armsFiles.Height is null then 0 else armsFiles.Height end as ArmsURLHeight,
	SCAGroups.ArmsBlazon,
	SCAGroups.BranchStatusId,
	SCAGroups.Notes,
	case when SovereignArmsFiles.FileName is null then SCAGroups.SovereignArmsUrl else SovereignArmsFiles.Folder + SovereignArmsFiles.FileName end as SovereignArmsUrl,
	case when SovereignArmsFiles.Width is null then 0 else SovereignArmsFiles.Width end as SovereignArmsUrlWidth,
	case when SovereignArmsFiles.Height is null then 0 else SovereignArmsFiles.Height end as SovereignArmsUrlHeight,
	SCAGroups.SovereignBlazon,
	case when ConsortArmsFiles.FileName is null then SCAGroups.ConsortArmsUrl else ConsortArmsFiles.Folder + ConsortArmsFiles.FileName end as ConsortArmsUrl,
	case when ConsortArmsFiles.Width is null then 0 else ConsortArmsFiles.Width end as ConsortArmsUrlWidth,
	case when ConsortArmsFiles.Height is null then 0 else ConsortArmsFiles.Height end as ConsortArmsUrlHeight,
	SCAGroups.ConsortBlazon,
	SCAGroups.SovereignMaleTitle,
	SCAGroups.SovereignFemaleTitle,
	SCAGroups.ConsortMaleTitle,
	SCAGroups.ConsortFemaleTitle,
	SCAGroups.ParentGroupId,
	SCAGroups.WebSiteUrl,
	SCAGroups.InternalUrl,
	SCAGroups.ReignType,
	SCAGroups.RegentMaleTitle,
	SCAGroups.RegentFemaleTitle,
	CASE WHEN ParentGroup.Name IS NULL THEN SCAGroups.Name ELSE ParentGroup.Name END AS ParentGroupName
FROM SCAGroups
LEFT JOIN SCAGroups ParentGroup ON SCAGroups.ParentGroupId = ParentGroup.GroupId
left join Files armsFiles on SCAGroups.ArmsURL = ''fileid='' + convert(varchar,armsFiles.FileID)
left join Files SovereignArmsFiles on SCAGroups.SovereignArmsUrl = ''fileid='' + convert(varchar,SovereignArmsFiles.FileID)
left join Files ConsortArmsFiles on SCAGroups.ConsortArmsUrl = ''fileid='' + convert(varchar,ConsortArmsFiles.FileID)
Order by SCAGroups.Name
ELSE
BEGIN
SET @SQL = ''
SELECT
	SCAGroups.GroupId,
	SCAGroups.Name,
	SCAGroups.Name as GroupName,
	SCAGroups.Code,
	SCAGroups.Location,
	SCAGroups.Precedence,
	SCAGroups.Hidden,
	case when armsFiles.FileName is null then SCAGroups.ArmsURL else armsFiles.Folder + armsFiles.FileName end as ArmsURL,
	case when armsFiles.Width is null then 0 else armsFiles.Width end as ArmsURLWidth,
	case when armsFiles.Height is null then 0 else armsFiles.Height end as ArmsURLHeight,
	SCAGroups.ArmsBlazon,
	SCAGroups.BranchStatusId,
	SCAGroups.Notes,
	case when SovereignArmsFiles.FileName is null then SCAGroups.SovereignArmsUrl else SovereignArmsFiles.Folder + SovereignArmsFiles.FileName end as SovereignArmsUrl,
	case when SovereignArmsFiles.Width is null then 0 else SovereignArmsFiles.Width end as SovereignArmsUrlWidth,
	case when SovereignArmsFiles.Height is null then 0 else SovereignArmsFiles.Height end as SovereignArmsUrlHeight,
	SCAGroups.SovereignBlazon,
	case when ConsortArmsFiles.FileName is null then SCAGroups.ConsortArmsUrl else ConsortArmsFiles.Folder + ConsortArmsFiles.FileName end as ConsortArmsUrl,
	case when ConsortArmsFiles.Width is null then 0 else ConsortArmsFiles.Width end as ConsortArmsUrlWidth,
	case when ConsortArmsFiles.Height is null then 0 else ConsortArmsFiles.Height end as ConsortArmsUrlHeight,
	SCAGroups.ConsortBlazon,
	SCAGroups.SovereignMaleTitle,
	SCAGroups.SovereignFemaleTitle,
	SCAGroups.ConsortMaleTitle,
	SCAGroups.ConsortFemaleTitle,
	SCAGroups.ParentGroupId,
	SCAGroups.WebSiteUrl,
	SCAGroups.InternalUrl,
	CASE WHEN ParentGroup.Name IS NULL THEN SCAGroups.Name ELSE ParentGroup.Name END AS ParentGroupName
FROM SCAGroups
LEFT JOIN SCAGroups ParentGroup ON SCAGroups.ParentGroupId = ParentGroup.GroupId
left join Files armsFiles on SCAGroups.ArmsURL = ''''fileid='''' + convert(varchar,armsFiles.FileID)
left join Files SovereignArmsFiles on SCAGroups.SovereignArmsUrl = ''''fileid='''' + convert(varchar,SovereignArmsFiles.FileID)
left join Files ConsortArmsFiles on SCAGroups.ConsortArmsUrl = ''''fileid='''' + convert(varchar,ConsortArmsFiles.FileID)
WHERE SCAGroups.GroupId in ('' + @filter + '')
Order by SCAGroups.Name''

exec sp_executesql @sql
END' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAGroupsList]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroupsList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAGroupsList]
AS

SELECT
	SCAGroups.[GroupId],
	SCAGroups.[Name],
	SCAGroups.[Code],
	SCAGroups.[Location],
	SCAGroups.[Precedence],
	SCAGroups.[FoundingDate],
	SCAGroups.[GroupDesignationId],
	SCAGroups.[Hidden],
	SCAGroups.[ArmsUrl],
	SCAGroups.[ArmsBlazon],
	SCAGroups.[BranchStatusId],
	SCAGroups.[Notes],
	SCAGroups.[SovereignMaleTitle],
	SCAGroups.[SovereignFemaleTitle],
	SCAGroups.[ConsortMaleTitle],
	SCAGroups.[ConsortFemaleTitle],
	SCAGroups.[ParentGroupId],
	SCAGroups.[SovereignArmsUrl],
	SCAGroups.[SovereignBlazon],
	SCAGroups.[ConsortArmsUrl],
	SCAGroups.[WebSiteUrl],
	SCAGroups.[InternalUrl],
	SCAGroups.[ConsortBlazon],
	SCAGroups.[ReignType],
	SCAGroups.[RegentMaleTitle],
	SCAGroups.[RegentFemaleTitle],
	SCAGroups.[RegentType],
	ParentGroup.Name AS ParentGroupName
FROM SCAGroups
LEFT JOIN SCAGroups ParentGroup ON SCAGroups.ParentGroupId = ParentGroup.GroupId
Order by SCAGroups.Name
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAGroupsGetByGroupDesignation]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroupsGetByGroupDesignation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAGroupsGetByGroupDesignation]
	@GroupDesignationId int = 0,
	@GroupDesignation varchar(50) = ''''
AS

SELECT
	SCAGroups.GroupId,
	SCAGroups.Name,
	SCAGroups.Name as GroupName,
	SCAGroups.Code,
	SCAGroups.Location,
	SCAGroups.Precedence,
	SCAGroups.[FoundingDate],
	SCAGroups.[GroupDesignationId],
	SCAGroups.Hidden,
	case when armsFiles.FileName is null then SCAGroups.ArmsURL else armsFiles.Folder + armsFiles.FileName end as ArmsURL,
	case when armsFiles.Width is null then 0 else armsFiles.Width end as ArmsURLWidth,
	case when armsFiles.Height is null then 0 else armsFiles.Height end as ArmsURLHeight,
	SCAGroups.ArmsBlazon,
	SCAGroups.BranchStatusId,
	SCAGroups.Notes,
	case when SovereignArmsFiles.FileName is null then SCAGroups.SovereignArmsUrl else SovereignArmsFiles.Folder + SovereignArmsFiles.FileName end as SovereignArmsUrl,
	case when SovereignArmsFiles.Width is null then 0 else SovereignArmsFiles.Width end as SovereignArmsUrlWidth,
	case when SovereignArmsFiles.Height is null then 0 else SovereignArmsFiles.Height end as SovereignArmsUrlHeight,
	SCAGroups.SovereignBlazon,
	case when ConsortArmsFiles.FileName is null then SCAGroups.ConsortArmsUrl else ConsortArmsFiles.Folder + ConsortArmsFiles.FileName end as ConsortArmsUrl,
	case when ConsortArmsFiles.Width is null then 0 else ConsortArmsFiles.Width end as ConsortArmsUrlWidth,
	case when ConsortArmsFiles.Height is null then 0 else ConsortArmsFiles.Height end as ConsortArmsUrlHeight,
	SCAGroups.ConsortBlazon,
	SCAGroups.SovereignMaleTitle,
	SCAGroups.SovereignFemaleTitle,
	SCAGroups.ConsortMaleTitle,
	SCAGroups.ConsortFemaleTitle,
	SCAGroups.ParentGroupId,
	SCAGroups.WebSiteUrl,
	SCAGroups.InternalUrl,
	SCAGroups.ReignType,
	SCAGroups.[RegentType],
	SCAGroups.RegentMaleTitle,
	SCAGroups.RegentFemaleTitle,
	CASE WHEN ParentGroup.Name IS NULL THEN SCAGroups.Name ELSE ParentGroup.Name END AS ParentGroupName
FROM SCAGroups
LEFT JOIN SCAGroups ParentGroup ON SCAGroups.ParentGroupId = ParentGroup.GroupId
left join Files armsFiles on SCAGroups.ArmsURL = ''fileid='' + convert(varchar,armsFiles.FileID)
left join Files SovereignArmsFiles on SCAGroups.SovereignArmsUrl = ''fileid='' + convert(varchar,SovereignArmsFiles.FileID)
left join Files ConsortArmsFiles on SCAGroups.ConsortArmsUrl = ''fileid='' + convert(varchar,ConsortArmsFiles.FileID)
JOIN SCAGroupDesignation on SCAGroups.GroupDesignationId = SCAGroupDesignation.GroupDesignationId
WHERE
	(SCAGroups.[GroupDesignationId]=@GroupDesignationId and @GroupDesignation = '''') OR
	(@GroupDesignationId= 0 AND SCAGroupDesignation.Name = @GroupDesignation)
Order By SCAGroups.Name

' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAGroupsGetByBranchStatusId]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroupsGetByBranchStatusId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAGroupsGetByBranchStatusId]
	@BranchStatusId int
AS

SELECT
	[GroupId],
	[Name],
	[Code],
	[Location],
	[Precedence],
	[Hidden],
	[ArmsUrl],
	[ArmsBlazon],
	[BranchStatusId],
	[Notes]
FROM SCAGroups
WHERE
	[BranchStatusId]=@BranchStatusId
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAGroupsGet]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroupsGet]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAGroupsGet]
	@GroupId int
	
AS
SELECT
	SCAGroups.GroupId,
	SCAGroups.Name,
	SCAGroups.Name as GroupName,
	SCAGroups.Code,
	SCAGroups.Location,
	SCAGroups.Precedence,
	SCAGroups.[FoundingDate],
	SCAGroups.[GroupDesignationId],
	SCAGroups.Hidden,
	case when armsFiles.FileName is null then SCAGroups.ArmsURL else armsFiles.Folder + armsFiles.FileName end as ArmsURL,
	case when armsFiles.Width is null then 0 else armsFiles.Width end as ArmsURLWidth,
	case when armsFiles.Height is null then 0 else armsFiles.Height end as ArmsURLHeight,
	SCAGroups.ArmsBlazon,
	SCAGroups.BranchStatusId,
	SCABranchStatus.Name as BranchStatus,
	SCAGroups.Notes,
	case when SovereignArmsFiles.FileName is null then SCAGroups.SovereignArmsUrl else SovereignArmsFiles.Folder + SovereignArmsFiles.FileName end as SovereignArmsUrl,
	case when SovereignArmsFiles.Width is null then 0 else SovereignArmsFiles.Width end as SovereignArmsUrlWidth,
	case when SovereignArmsFiles.Height is null then 0 else SovereignArmsFiles.Height end as SovereignArmsUrlHeight,
	SCAGroups.SovereignBlazon,
	case when ConsortArmsFiles.FileName is null then SCAGroups.ConsortArmsUrl else ConsortArmsFiles.Folder + ConsortArmsFiles.FileName end as ConsortArmsUrl,
	case when ConsortArmsFiles.Width is null then 0 else ConsortArmsFiles.Width end as ConsortArmsUrlWidth,
	case when ConsortArmsFiles.Height is null then 0 else ConsortArmsFiles.Height end as ConsortArmsUrlHeight,
	SCAGroups.ConsortBlazon,
	SCAGroups.SovereignMaleTitle,
	SCAGroups.SovereignFemaleTitle,
	SCAGroups.ConsortMaleTitle,
	SCAGroups.ConsortFemaleTitle,
	SCAGroups.ParentGroupId,
	SCAGroups.WebSiteUrl,
	SCAGroups.InternalUrl,
	SCAGroups.ReignType,
	SCAGroups.[RegentType],
	SCAGroups.RegentMaleTitle,
	SCAGroups.RegentFemaleTitle,
	CASE WHEN ParentGroup.Name IS NULL THEN SCAGroups.Name ELSE ParentGroup.Name END AS ParentGroupName
FROM SCAGroups
LEFT JOIN SCAGroups ParentGroup ON SCAGroups.ParentGroupId = ParentGroup.GroupId
left join Files armsFiles on SCAGroups.ArmsURL = ''fileid='' + convert(varchar,armsFiles.FileID)
left join Files SovereignArmsFiles on SCAGroups.SovereignArmsUrl = ''fileid='' + convert(varchar,SovereignArmsFiles.FileID)
left join Files ConsortArmsFiles on SCAGroups.ConsortArmsUrl = ''fileid='' + convert(varchar,ConsortArmsFiles.FileID)
left join SCABranchStatus on SCAGroups.BranchStatusId = SCABranchStatus.BranchStatusId
WHERE
	SCAGroups.[GroupId] = @GroupId
	
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAGroupsDelete]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroupsDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAGroupsDelete]
	@GroupId int
AS

DELETE FROM SCAGroups
WHERE
	[GroupId] = @GroupId
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAGroupsAdd]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroupsAdd]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAGroupsAdd]
@Name varchar(300),
	@Code varchar(50),
	@Location varchar(200),
	@Precedence int,
	@FoundingDate datetime,
	@GroupDesignationId int,
	@Hidden bit,
	@ArmsUrl varchar(300),
	@ArmsBlazon nvarchar(4000),
	@BranchStatusId int,
	@Notes text,
	@SovereignMaleTitle varchar(50),
	@SovereignFemaleTitle varchar(50),
	@ConsortMaleTitle varchar(50),
	@ConsortFemaleTitle varchar(50),
	@ParentGroupId int,
	@SovereignArmsUrl varchar(300),
	@SovereignBlazon varchar(300),
	@ConsortArmsUrl varchar(300),
	@WebSiteUrl varchar(300),
	@InternalUrl varchar(300),
	@ConsortBlazon varchar(300),
	@ReignType varchar(50),
	@RegentMaleTitle varchar(50),
	@RegentFemaleTitle varchar(50),
	@RegentType varchar(50)
AS

INSERT INTO SCAGroups (
	[Name],
	[Code],
	[Location],
	[Precedence],
	[FoundingDate],
	[GroupDesignationId],
	[Hidden],
	[ArmsUrl],
	[ArmsBlazon],
	[BranchStatusId],
	[Notes],
	[SovereignMaleTitle],
	[SovereignFemaleTitle],
	[ConsortMaleTitle],
	[ConsortFemaleTitle],
	[ParentGroupId],
	[SovereignArmsUrl],
	[SovereignBlazon],
	[ConsortArmsUrl],
	[WebSiteUrl],
	[InternalUrl],
	[ConsortBlazon],
	[ReignType],
	[RegentMaleTitle],
	[RegentFemaleTitle],
	[RegentType]
) VALUES (
	@Name,
	@Code,
	@Location,
	@Precedence,
	@FoundingDate,
	@GroupDesignationId,
	@Hidden,
	@ArmsUrl,
	@ArmsBlazon,
	@BranchStatusId,
	@Notes,
	@SovereignMaleTitle,
	@SovereignFemaleTitle,
	@ConsortMaleTitle,
	@ConsortFemaleTitle,
	@ParentGroupId,
	@SovereignArmsUrl,
	@SovereignBlazon,
	@ConsortArmsUrl,
	@WebSiteUrl,
	@InternalUrl,
	@ConsortBlazon,
	@ReignType,
	@RegentMaleTitle,
	@RegentFemaleTitle,
	@RegentType
)

select SCOPE_IDENTITY()' 
END
GO
/****** Object:  Table {databaseOwner}.{objectQualifier}[SCAGroupZipCodes]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroupZipCodes]') AND type in (N'U'))
BEGIN
CREATE TABLE {databaseOwner}.{objectQualifier}[SCAGroupZipCodes](
	[GroupId] [int] NOT NULL,
	[Zip] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_SCAGroupZipCodes] PRIMARY KEY CLUSTERED 
(
	[GroupId] ASC,
	[Zip] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAGroupsUpdate]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroupsUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAGroupsUpdate]
	@GroupId int, 
	@Name varchar(300), 
	@Code varchar(50), 
	@Location varchar(200), 
	@Precedence int, 
	@FoundingDate datetime, 
	@GroupDesignationId int, 
	@Hidden bit, 
	@ArmsUrl varchar(300), 
	@ArmsBlazon nvarchar(4000), 
	@BranchStatusId int, 
	@Notes text, 
	@SovereignMaleTitle varchar(50), 
	@SovereignFemaleTitle varchar(50), 
	@ConsortMaleTitle varchar(50), 
	@ConsortFemaleTitle varchar(50), 
	@ParentGroupId int, 
	@SovereignArmsUrl varchar(300), 
	@SovereignBlazon varchar(300), 
	@ConsortArmsUrl varchar(300), 
	@WebSiteUrl varchar(300), 
	@InternalUrl varchar(300), 
	@ConsortBlazon varchar(300), 
	@ReignType varchar(50), 
	@RegentMaleTitle varchar(50), 
	@RegentFemaleTitle varchar(50), 
	@RegentType varchar(50)
AS

UPDATE SCAGroups SET
	[Name] = @Name,
	[Code] = @Code,
	[Location] = @Location,
	[Precedence] = @Precedence,
	[FoundingDate] = @FoundingDate,
	[GroupDesignationId] = @GroupDesignationId,
	[Hidden] = @Hidden,
	[ArmsUrl] = @ArmsUrl,
	[ArmsBlazon] = @ArmsBlazon,
	[BranchStatusId] = @BranchStatusId,
	[Notes] = @Notes,
	[SovereignMaleTitle] = @SovereignMaleTitle,
	[SovereignFemaleTitle] = @SovereignFemaleTitle,
	[ConsortMaleTitle] = @ConsortMaleTitle,
	[ConsortFemaleTitle] = @ConsortFemaleTitle,
	[ParentGroupId] = @ParentGroupId,
	[SovereignArmsUrl] = @SovereignArmsUrl,
	[SovereignBlazon] = @SovereignBlazon,
	[ConsortArmsUrl] = @ConsortArmsUrl,
	[WebSiteUrl] = @WebSiteUrl,
	[InternalUrl] = @InternalUrl,
	[ConsortBlazon] = @ConsortBlazon,
	[ReignType] = @ReignType,
	[RegentMaleTitle] = @RegentMaleTitle,
	[RegentFemaleTitle] = @RegentFemaleTitle,
	[RegentType] = @RegentType
WHERE
	[GroupId] = @GroupId' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAGroupsListGroups]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroupsListGroups]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAGroupsListGroups]
AS
WITH GroupTree(GroupId, Name, GroupName, Level, Sort)
AS 
(
SELECT
	SCAGroups.GroupId,
	SCAGroups.Name,
	SCAGroups.Name as GroupName,
	1,
    CONVERT(varchar(max), CONVERT(char(50), SCAGroups.Name) + ''|'')
FROM SCAGroups
where ParentGroupId is null
UNION ALL 
SELECT 
SCAGroups.GroupId,
	SCAGroups.Name,
	SCAGroups.Name as GroupName,
    Level + 1,
CONVERT(varchar(max), Sort + CONVERT(char(50), SCAGroups.Name) + ''|'')
FROM SCAGroups
JOIN GroupTree  ON SCAGroups.ParentGroupId = GroupTree.GroupId
)
SELECT GroupId,
GroupName,
Level,
RTRIM(SUBSTRING(sort, 1, 50)) AS lvl1,
RTRIM(SUBSTRING(sort, 52, 50)) AS lvl2,
RTRIM(SUBSTRING(sort, 103, 50)) AS lvl3,
RTRIM(SUBSTRING(sort, 154, 50)) AS lvl4
From GroupTree
Order By Sort' 
END
GO
/****** Object:  Table {databaseOwner}.{objectQualifier}[SCAOfficerPosition]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAOfficerPosition]') AND type in (N'U'))
BEGIN
CREATE TABLE {databaseOwner}.{objectQualifier}[SCAOfficerPosition](
	[OfficerPositionId] [int] IDENTITY(1,1) NOT NULL,
	[Title] [varchar](200) NOT NULL,
	[GroupId] [int] NULL,
	[ListOrder] [int] NOT NULL,
	[BadgeURL] [nvarchar](300) NULL,
	[OfficeEmail] [nvarchar](100) NULL,
	[LinkedToCrown] [bit] NOT NULL,
 CONSTRAINT [PK_SCAOfficerPosition] PRIMARY KEY CLUSTERED 
(
	[OfficerPositionId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table {databaseOwner}.{objectQualifier}[SCACrowns]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCACrowns]') AND type in (N'U'))
BEGIN
CREATE TABLE {databaseOwner}.{objectQualifier}[SCACrowns](
	[CrownId] [int] IDENTITY(1,1) NOT NULL,
	[GroupId] [int] NOT NULL,
	[Reign] [int] NOT NULL,
	[SovereignId] [int] NOT NULL,
	[ConsortId] [int] NULL,
	[Notes] [varchar](8000) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[CoronationLocation] [varchar](500) NULL,
	[CrownTournamentDate] [datetime] NULL,
	[CrownTournamentLocation] [varchar](500) NULL,
	[SteppingDownLocation] [varchar](500) NULL,
	[InternalUrl] [varchar](300) NULL,
	[Heir] [bit] NOT NULL,
	[Picture1Url] [varchar](300) NULL,
	[Picture2Url] [varchar](300) NULL,
	[Picture1Caption] [nvarchar](1000) NULL,
	[Picture2Caption] [nvarchar](1000) NULL,
	[Picture1Credit] [nvarchar](1000) NULL,
	[Picture2Credit] [nvarchar](1000) NULL,
	[Email] [nvarchar](100) NULL,
	[Regent] [bit] NOT NULL,
 CONSTRAINT [PK_SCACrowns] PRIMARY KEY CLUSTERED 
(
	[CrownId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table {databaseOwner}.{objectQualifier}[SCAAwardGroups]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAwardGroups]') AND type in (N'U'))
BEGIN
CREATE TABLE {databaseOwner}.{objectQualifier}[SCAAwardGroups](
	[AwardGroupId] [int] IDENTITY(1,1) NOT NULL,
	[AwardGroupName] [varchar](200) NOT NULL,
	[Precedence] [int] NOT NULL,
	[SortOrder] [int] NULL,
	[GroupId] [int] NOT NULL,
 CONSTRAINT [PK_SCAAwardGroups] PRIMARY KEY CLUSTERED 
(
	[AwardGroupId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table {databaseOwner}.{objectQualifier}[SCAAlias]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAlias]') AND type in (N'U'))
BEGIN
CREATE TABLE {databaseOwner}.{objectQualifier}[SCAAlias](
	[AliasId] [int] IDENTITY(1,1) NOT NULL,
	[PeopleId] [int] NOT NULL,
	[SCAName] [nvarchar](300) NOT NULL,
	[Registered] [bit] NOT NULL,
	[Preferred] [bit] NOT NULL,
 CONSTRAINT [PK_SCAAlias] PRIMARY KEY CLUSTERED 
(
	[AliasId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table {databaseOwner}.{objectQualifier}[SCAAwards]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAwards]') AND type in (N'U'))
BEGIN
CREATE TABLE {databaseOwner}.{objectQualifier}[SCAAwards](
	[AwardId] [int] IDENTITY(1,1) NOT NULL,
	[GroupId] [int] NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Charter] [ntext] NULL,
	[Precedence] [int] NULL,
	[BadgeUrl] [varchar](300) NULL,
	[BadgeBlazon] [nvarchar](4000) NULL,
	[Closed] [bit] NOT NULL,
	[AwardedById] [int] NULL,
	[SortOrder] [int] NULL,
	[AwardGroupId] [int] NULL,
	[Honorary] [bit] NOT NULL,
 CONSTRAINT [PK_SCAAwards] PRIMARY KEY CLUSTERED 
(
	[AwardId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAwards]') AND name = N'IX_AwardId_Precedence')
CREATE NONCLUSTERED INDEX [IX_AwardId_Precedence] ON {databaseOwner}.{objectQualifier}[SCAAwards] 
(
	[AwardId] ASC,
	[Precedence] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAAwardGroupsUpdate]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAwardGroupsUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAAwardGroupsUpdate]
	@AwardGroupId int, 
	@AwardGroupName varchar(200), 
	@Precedence int, 
	@SortOrder int, 
	@GroupId int 
AS

UPDATE SCAAwardGroups SET
	[AwardGroupName] = @AwardGroupName,
	[Precedence] = @Precedence,
	[SortOrder] = @SortOrder,
	[GroupId] = @GroupId
WHERE
	[AwardGroupId] = @AwardGroupId

' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAAwardGroupsList]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAwardGroupsList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAAwardGroupsList]
AS

SELECT
	SCAAwardGroups.[AwardGroupId],
	SCAAwardGroups.[AwardGroupName],
	SCAAwardGroups.[Precedence],
	SCAAwardGroups.[SortOrder],
	SCAAwardGroups.[GroupId],
	SCAGroups.Name as GroupName,
	SCAAwardGroups.[AwardGroupName] + '' ('' + COALESCE(SCAGroups.Code, SCAGroups.Name) + '')'' as AwardGroupNameGroup
FROM SCAAwardGroups
JOIN SCAGRoups on SCAGroups.GroupId = SCAAwardGroups.GroupId

' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAAwardGroupsGetByGroups]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAwardGroupsGetByGroups]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAAwardGroupsGetByGroups]
	@GroupId int
AS

SELECT
	[AwardGroupId],
	[AwardGroupName],
	[Precedence],
	[SortOrder],
	[GroupId]
FROM SCAAwardGroups
WHERE
	[GroupId]=@GroupId

' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAAwardGroupsGet]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAwardGroupsGet]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAAwardGroupsGet]
	@AwardGroupId int
	
AS

SELECT
	[AwardGroupId],
	[AwardGroupName],
	[Precedence],
	[SortOrder],
	[GroupId]
FROM SCAAwardGroups
WHERE
	[AwardGroupId] = @AwardGroupId
	

' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAAwardGroupsDelete]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAwardGroupsDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAAwardGroupsDelete]
	@AwardGroupId int
AS

DELETE FROM SCAAwardGroups
WHERE
	[AwardGroupId] = @AwardGroupId

' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAAwardGroupsAdd]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAwardGroupsAdd]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAAwardGroupsAdd]
	@AwardGroupName varchar(200),
	@Precedence int,
	@SortOrder int,
	@GroupId int
AS

INSERT INTO SCAAwardGroups (
	[AwardGroupName],
	[Precedence],
	[SortOrder],
	[GroupId]
) VALUES (
	@AwardGroupName,
	@Precedence,
	@SortOrder,
	@GroupId
)

select SCOPE_IDENTITY()

' 
END
GO
/****** Object:  Table {databaseOwner}.{objectQualifier}[SCACrownLetters]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCACrownLetters]') AND type in (N'U'))
BEGIN
CREATE TABLE {databaseOwner}.{objectQualifier}[SCACrownLetters](
	[CrownLetterId] [int] IDENTITY(1,1) NOT NULL,
	[CrownId] [int] NOT NULL,
	[Title] [varchar](200) NOT NULL,
	[Letter] [ntext] NULL,
 CONSTRAINT [PK_SCACrownLetters] PRIMARY KEY CLUSTERED 
(
	[CrownLetterId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCACrownsUpdate]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCACrownsUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCACrownsUpdate]
	@CrownId int, 
	@GroupId int, 
	@Reign int, 
	@SovereignId int, 
	@ConsortId int, 
	@Notes varchar(8000), 
	@StartDate datetime, 
	@EndDate datetime, 
	@CoronationLocation varchar(500), 
	@CrownTournamentDate datetime, 
	@CrownTournamentLocation varchar(500), 
	@SteppingDownLocation varchar(500), 
	@InternalUrl varchar(300), 
	@Heir bit, 
	@Picture1Url varchar(300), 
	@Picture2Url varchar(300), 
	@Picture1Caption nvarchar(1000), 
	@Picture2Caption nvarchar(1000), 
	@Picture1Credit nvarchar(1000), 
	@Picture2Credit nvarchar(1000) ,
	@Email nvarchar(100),
	@Regent bit
AS

UPDATE SCACrowns SET
	[GroupId] = @GroupId,
	[Reign] = @Reign,
	[SovereignId] = @SovereignId,
	[ConsortId] = @ConsortId,
	[Notes] = @Notes,
	[StartDate] = @StartDate,
	[EndDate] = @EndDate,
	[CoronationLocation] = @CoronationLocation,
	[CrownTournamentDate] = @CrownTournamentDate,
	[CrownTournamentLocation] = @CrownTournamentLocation,
	[SteppingDownLocation] = @SteppingDownLocation,
	[InternalUrl] = @InternalUrl,
	[Heir] = @Heir,
	[Picture1Url] = @Picture1Url,
	[Picture2Url] = @Picture2Url,
	[Picture1Caption] = @Picture1Caption,
	[Picture2Caption] = @Picture2Caption,
	[Picture1Credit] = @Picture1Credit,
	[Picture2Credit] = @Picture2Credit,
	[Email] = @Email,
	[Regent] = @Regent
WHERE
	[CrownId] = @CrownId
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCACrownsList]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCACrownsList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCACrownsList]
AS

SELECT
	SCACrowns.CrownId,
	SCACrowns.GroupId,
	SCACrowns.Reign,
	SCACrowns.SovereignId,
	SCACrowns.ConsortId,
	SCACrowns.Notes,
	SCACrowns.StartDate,
	SCACrowns.EndDate,
	SCACrowns.CoronationLocation,
	SCACrowns.CrownTournamentDate,
	SCACrowns.CrownTournamentLocation,
	SCACrowns.SteppingDownLocation,
	SCACrowns.Heir,
	SCACrowns.Email,
	SCACrowns.Regent,
	SCAGroups.Name AS GroupName,
	Sovereign.SCAName AS SovereignName,
	Consort.SCAName AS ConsortName,
	CASE 
		WHEN LEFT(Sovereign.SCAName, CASE WHEN PATINDEX(''% %'',Sovereign.SCAName)>0 THEN PATINDEX(''% %'',Sovereign.SCAName) -1 ELSE 0 END) = '''' THEN Sovereign.SCAName 
		ELSE LEFT(Sovereign.SCAName, CASE WHEN PATINDEX(''% %'',Sovereign.SCAName)>0 THEN PATINDEX(''% %'',Sovereign.SCAName) -1 ELSE 0 END) END + 
	CASE 
		WHEN Consort.SCAName IS NULL THEN '''' 
		ELSE '' and '' END + 
	CASE 
		WHEN Consort.SCAName IS NULL THEN ''''  
		WHEN LEFT(Consort.SCAName,CASE WHEN PATINDEX(''% %'',Consort.SCAName)>0 THEN PATINDEX(''% %'',Consort.SCAName) -1 ELSE 0 END) = '''' THEN Consort.SCAName 
		ELSE LEFT(Consort.SCAName,CASE WHEN PATINDEX(''% %'',Consort.SCAName)>0 THEN PATINDEX(''% %'',Consort.SCAName) -1 ELSE 0 END) END 
	AS Rulers,
	SCAGroups.Name + ''-'' + CASE WHEN LEFT(Sovereign.SCAName,
	CASE WHEN PATINDEX(''% %'',Sovereign.SCAName)>0 THEN PATINDEX(''% %'',Sovereign.SCAName) -1 ELSE 0 END) = '''' THEN Sovereign.SCAName ELSE LEFT(Sovereign.SCAName,
	CASE WHEN PATINDEX(''% %'',Sovereign.SCAName)>0 THEN PATINDEX(''% %'',Sovereign.SCAName) -1 ELSE 0 END) END + '' & '' + CASE WHEN LEFT(Consort.SCAName,
	CASE WHEN PATINDEX(''% %'',Consort.SCAName)>0 THEN PATINDEX(''% %'',Consort.SCAName) -1 ELSE 0 END) = '''' THEN Consort.SCAName ELSE LEFT(Consort.SCAName,
	CASE WHEN PATINDEX(''% %'',Consort.SCAName)>0 THEN PATINDEX(''% %'',Consort.SCAName) -1 ELSE 0 END) END + '' Rgn:'' + CAST(SCACrowns.Reign AS varchar)
	+ '' '' + CASE WHEN SCACrowns.StartDate IS NULL THEN ''unknown date'' ELSE CAST(Month(SCACrowns.StartDate) as varchar) + ''/'' + CAST(Year(SCACrowns.StartDate) as varchar)+ ''-'' +
	CASE WHEN SCACrowns.EndDate IS NULL THEN ''present'' ELSE  CAST(Month(SCACrowns.EndDate) as varchar) + ''/'' + CAST(Year(SCACrowns.EndDate)as varchar) END END AS GroupCrownReign,
	[Picture1Url],
	[Picture2Url],
	[Picture1Caption],
	[Picture2Caption],
	[Picture1Credit],
	[Picture2Credit]
FROM SCAPeople Sovereign
JOIN SCACrowns
JOIN SCAGroups ON SCAGroups.GroupId = SCACrowns.GroupId ON Sovereign.PeopleId = SCACrowns.SovereignId
JOIN SCAPeople Consort ON SCACrowns.ConsortId = Consort.PeopleId
Order by groupname,
	reign 




' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCACrownsGetByGroups]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCACrownsGetByGroups]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCACrownsGetByGroups]
	@GroupId int
AS

SELECT
	SCACrowns.CrownId,
	SCACrowns.GroupId,
	CASE 
		WHEN SCACrowns.Regent=1 THEN
			SCAGroups.RegentType
		ELSE 
			Cast(SCACrowns.Reign as varchar)
		END as Reign,
	SCAGroups.RegentMaleTitle,
	SCAGroups.RegentFemaleTitle,
	SCACrowns.SovereignId,
	SCACrowns.ConsortId,
	SCACrowns.Notes,
	SCACrowns.StartDate,
	SCACrowns.EndDate,
	SCACrowns.CoronationLocation,
	SCACrowns.CrownTournamentDate,
	SCACrowns.CrownTournamentLocation,
	SCACrowns.SteppingDownLocation,
	SCACrowns.Heir,
	SCACrowns.InternalUrl,
	SCACrowns.Email,
	SCACrowns.Regent,
	Sovereign.SCAName AS SovereignName,
	Consort.SCAName AS ConsortName,
	CASE 
		WHEN LEFT(Sovereign.SCAName, CASE WHEN PATINDEX(''% %'',Sovereign.SCAName)>0 THEN PATINDEX(''% %'',Sovereign.SCAName) -1 ELSE 0 END) = '''' THEN Sovereign.SCAName 
		ELSE LEFT(Sovereign.SCAName, CASE WHEN PATINDEX(''% %'',Sovereign.SCAName)>0 THEN PATINDEX(''% %'',Sovereign.SCAName) -1 ELSE 0 END) END + 
	CASE 
		WHEN Consort.SCAName IS NULL THEN '''' 
		ELSE '' and '' END + 
	CASE 
		WHEN Consort.SCAName IS NULL THEN ''''  
		WHEN LEFT(Consort.SCAName,CASE WHEN PATINDEX(''% %'',Consort.SCAName)>0 THEN PATINDEX(''% %'',Consort.SCAName) -1 ELSE 0 END) = '''' THEN Consort.SCAName 
		ELSE LEFT(Consort.SCAName,CASE WHEN PATINDEX(''% %'',Consort.SCAName)>0 THEN PATINDEX(''% %'',Consort.SCAName) -1 ELSE 0 END) END 
	AS Rulers,
	SCAGroups.Name + ''-'' + CASE WHEN LEFT(Sovereign.SCAName,
	CASE WHEN PATINDEX(''% %'',Sovereign.SCAName)>0 THEN PATINDEX(''% %'',Sovereign.SCAName) -1 ELSE 0 END) = '''' THEN Sovereign.SCAName ELSE LEFT(Sovereign.SCAName,
	CASE WHEN PATINDEX(''% %'',Sovereign.SCAName)>0 THEN PATINDEX(''% %'',Sovereign.SCAName) -1 ELSE 0 END) END + '' & '' + CASE WHEN LEFT(Consort.SCAName,
	CASE WHEN PATINDEX(''% %'',Consort.SCAName)>0 THEN PATINDEX(''% %'',Consort.SCAName) -1 ELSE 0 END) = '''' THEN Consort.SCAName ELSE LEFT(Consort.SCAName,
	CASE WHEN PATINDEX(''% %'',Consort.SCAName)>0 THEN PATINDEX(''% %'',Consort.SCAName) -1 ELSE 0 END) END + '' Rgn:'' + CAST(SCACrowns.Reign AS varchar)
	+ '' '' + CASE WHEN SCACrowns.StartDate IS NULL THEN ''unknown'' ELSE CAST(Month(SCACrowns.StartDate) as varchar) + ''/'' + CAST(Year(SCACrowns.StartDate) as varchar)+ ''-'' +
	CASE WHEN SCACrowns.EndDate IS NULL THEN ''present'' ELSE  CAST(Month(SCACrowns.EndDate) as varchar) + ''/'' + CAST(Year(SCACrowns.EndDate)as varchar) END END AS GroupCrownReign,
	CAST(SCACrowns.Reign AS varchar) +'':''+ CASE WHEN LEFT(Sovereign.SCAName,
	CASE WHEN PATINDEX(''% %'',Sovereign.SCAName)>0 THEN PATINDEX(''% %'',Sovereign.SCAName) -1 ELSE 0 END) = '''' THEN Sovereign.SCAName ELSE LEFT(Sovereign.SCAName,
	CASE WHEN PATINDEX(''% %'',Sovereign.SCAName)>0 THEN PATINDEX(''% %'',Sovereign.SCAName) -1 ELSE 0 END) END + '' & '' + CASE WHEN LEFT(Consort.SCAName,
	CASE WHEN PATINDEX(''% %'',Consort.SCAName)>0 THEN PATINDEX(''% %'',Consort.SCAName) -1 ELSE 0 END) = '''' THEN Consort.SCAName ELSE LEFT(Consort.SCAName,
	CASE WHEN PATINDEX(''% %'',Consort.SCAName)>0 THEN PATINDEX(''% %'',Consort.SCAName) -1 ELSE 0 END) END
	+ '' '' + CASE WHEN SCACrowns.StartDate IS NULL THEN ''unknown'' ELSE CAST(Month(SCACrowns.StartDate) as varchar) + ''/'' + CAST(Year(SCACrowns.StartDate) as varchar)+ ''-'' +
	CASE WHEN SCACrowns.EndDate IS NULL THEN ''present'' ELSE  CAST(Month(SCACrowns.EndDate) as varchar) + ''/'' + CAST(Year(SCACrowns.EndDate)as varchar) END END AS ReignCrown,
	[Picture1Url],
	[Picture2Url],
	[Picture1Caption],
	[Picture2Caption],
	[Picture1Credit],
	[Picture2Credit]
FROM SCACrowns 
JOIN SCAPeople Sovereign ON SCACrowns.SovereignId = Sovereign.PeopleId 
LEFT JOIN SCAPeople Consort ON SCACrowns.ConsortId = Consort.PeopleId
JOIN SCAGroups ON SCACrowns.GroupId = SCAGroups.GroupId
WHERE (SCACrowns.GroupId = @GroupId)
ORDER BY Cast(SCACrowns.Reign as int), SCACrowns.StartDate

' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCACrownsGet]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCACrownsGet]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCACrownsGet]
	@CrownId int
	
AS

WITH NewFiles(FileName, Width, Height, FileId,Folder, FileJoin) AS
(
Select FileName, Width, Height, FileId, Folder, ''fileid=''+ convert(varchar,FileID)
FROM Files
)

SELECT
	SCACrowns.CrownId,
	SCACrowns.GroupId,
	SCACrowns.Reign,
	SCACrowns.SovereignId,
	SCACrowns.ConsortId,
	SCACrowns.Notes,
	SCACrowns.StartDate,
	SCACrowns.EndDate,
	SCACrowns.CoronationLocation,
	SCACrowns.CrownTournamentDate,
	SCACrowns.CrownTournamentLocation,
	SCACrowns.SteppingDownLocation,
	SCACrowns.Heir,
	SCACrowns.Regent,
	SCACrowns.InternalUrl,
	SCACrowns.Email,
	Sovereign.SCAName AS SovereignName,
	case when SovereignPersonalArmsFiles.FileName is null then Sovereign.ArmsURL else SovereignPersonalArmsFiles.Folder + SovereignPersonalArmsFiles.FileName end as SovereignPersonalArmsURL,
	case when SovereignPersonalArmsFiles.Width is null then 0 else SovereignPersonalArmsFiles.Width end as SovereignPersonalArmsWidth,
	case when SovereignPersonalArmsFiles.Height is null then 0 else SovereignPersonalArmsFiles.Height end as SovereignPersonalArmsHeight,
	Consort.SCAName AS ConsortName,
	case when ConsortPersonalArmsFiles.FileName is null then Consort.ArmsURL else ConsortPersonalArmsFiles.Folder + ConsortPersonalArmsFiles.FileName end as ConsortPersonalArmsURL,
	case when ConsortPersonalArmsFiles.Width is null then 0 else ConsortPersonalArmsFiles.Width end as ConsortPersonalArmsWidth,
	case when ConsortPersonalArmsFiles.Height is null then 0 else ConsortPersonalArmsFiles.Height end as ConsortPersonalArmsHeight,
	CASE 
		WHEN LEFT(Sovereign.SCAName, CASE WHEN PATINDEX(''% %'',Sovereign.SCAName)>0 THEN PATINDEX(''% %'',Sovereign.SCAName) -1 ELSE 0 END) = '''' THEN Sovereign.SCAName 
		ELSE LEFT(Sovereign.SCAName, CASE WHEN PATINDEX(''% %'',Sovereign.SCAName)>0 THEN PATINDEX(''% %'',Sovereign.SCAName) -1 ELSE 0 END) END + 
	CASE 
		WHEN Consort.SCAName IS NULL THEN '''' 
		ELSE '' and '' END + 
	CASE 
		WHEN Consort.SCAName IS NULL THEN ''''  
		WHEN LEFT(Consort.SCAName,CASE WHEN PATINDEX(''% %'',Consort.SCAName)>0 THEN PATINDEX(''% %'',Consort.SCAName) -1 ELSE 0 END) = '''' THEN Consort.SCAName 
		ELSE LEFT(Consort.SCAName,CASE WHEN PATINDEX(''% %'',Consort.SCAName)>0 THEN PATINDEX(''% %'',Consort.SCAName) -1 ELSE 0 END) END 
	AS Rulers,
	case when Pic1Files.FileName is null then [Picture1Url] else Pic1Files.Folder + Pic1Files.FileName end as [Picture1Url],
	case when Pic1Files.Width is null then 0 else Pic1Files.Width end as Picture1Width,
	case when Pic1Files.Height is null then 0 else Pic1Files.Height end as Picture1Height,
	case when Pic2Files.FileName is null then [Picture2Url] else Pic2Files.Folder + Pic2Files.FileName end as [Picture2Url],
	case when Pic2Files.Width is null then 0 else Pic2Files.Width end as Picture2Width,
	case when Pic2Files.Height is null then 0 else Pic2Files.Height end as Picture2Height,
	[Picture1Caption],
	[Picture2Caption],
	[Picture1Credit],
	[Picture2Credit],
	SCAGroups.GroupId,
	SCAGroups.Name as GroupName,
	SCAGroups.Code,
	SCAGroups.Location,
	SCAGroups.Precedence,
	SCAGroups.Hidden,
	case when armsFiles.FileName is null then SCAGroups.ArmsURL else armsFiles.Folder + armsFiles.FileName end as ArmsURL,
	case when armsFiles.Width is null then 0 else armsFiles.Width end as ArmsURLWidth,
	case when armsFiles.Height is null then 0 else armsFiles.Height end as ArmsURLHeight,
	SCAGroups.ArmsBlazon,
	SCAGroups.BranchStatusId,
	SCAGroups.Notes,
	case when SovereignArmsFiles.FileName is null then SCAGroups.SovereignArmsUrl else SovereignArmsFiles.Folder + SovereignArmsFiles.FileName end as SovereignArmsUrl,
	case when SovereignArmsFiles.Width is null then 0 else SovereignArmsFiles.Width end as SovereignArmsWidth,
	case when SovereignArmsFiles.Height is null then 0 else SovereignArmsFiles.Height end as SovereignArmsHeight,
	SCAGroups.SovereignBlazon,
	case when ConsortArmsFiles.FileName is null then SCAGroups.ConsortArmsUrl else ConsortArmsFiles.Folder + ConsortArmsFiles.FileName end as ConsortArmsUrl,
	case when ConsortArmsFiles.Width is null then 0 else ConsortArmsFiles.Width end as ConsortArmsWidth,
	case when ConsortArmsFiles.Height is null then 0 else ConsortArmsFiles.Height end as ConsortArmsHeight,
	SCAGroups.ConsortBlazon,
	SCAGroups.SovereignMaleTitle,
	SCAGroups.SovereignFemaleTitle,
	SCAGroups.ConsortMaleTitle,
	SCAGroups.ConsortFemaleTitle,
	SCAGroups.ParentGroupId,
	SCAGroups.WebSiteUrl,
	SCAGroups.InternalUrl,
	SCAGroups.ReignType,
	CASE WHEN ParentGroup.Name IS NULL THEN SCAGroups.Name ELSE ParentGroup.Name END AS ParentGroupName,
	CASE WHEN SCACrowns.Reign = (SELECT
		MAX(Reign)
	FROM SCACrowns wC
	WHERE wC.GroupId = SCAGroups.GroupId AND wC.Heir=0) OR heir =1  THEN 1 ELSE 0 END AS CurrentlyHeld
FROM SCAGroups
LEFT JOIN SCAGroups ParentGroup ON SCAGroups.ParentGroupId = ParentGroup.GroupId
left join NewFiles armsFiles on SCAGroups.ArmsURL = armsFiles.FileJoin
left join NewFiles SovereignArmsFiles on SCAGroups.SovereignArmsUrl = SovereignArmsFiles.FileJoin
left join NewFiles ConsortArmsFiles on SCAGroups.ConsortArmsUrl = ConsortArmsFiles.FileJoin
JOIN SCACrowns ON SCACrowns.GroupId = SCAGroups.GroupId
LEFT JOIN SCAPeople Sovereign ON SCACrowns.SovereignId = Sovereign.PeopleId 
LEFT JOIN SCAPeople Consort ON SCACrowns.ConsortId = Consort.PeopleId
left join NewFiles Pic1Files on SCACrowns.[Picture1Url] = Pic1Files.FileJoin
left join NewFiles Pic2Files on SCACrowns.[Picture2Url] = Pic2Files.FileJoin
left join NewFiles SovereignPersonalArmsFiles on Sovereign.[ArmsUrl] = SovereignPersonalArmsFiles.FileJoin
left join NewFiles ConsortPersonalArmsFiles on Consort.[ArmsUrl] = ConsortPersonalArmsFiles.FileJoin
WHERE
	SCACrowns.[CrownId] = @CrownId
	



' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCACrownsDelete]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCACrownsDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCACrownsDelete]
	@CrownId int
AS

DELETE FROM SCACrowns
WHERE
	[CrownId] = @CrownId
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCACrownsAdd]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCACrownsAdd]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCACrownsAdd]
	@GroupId int,
	@Reign int,
	@SovereignId int,
	@ConsortId int,
	@Notes varchar(8000),
	@StartDate datetime,
	@EndDate datetime,
	@CoronationLocation varchar(500),
	@CrownTournamentDate datetime,
	@CrownTournamentLocation varchar(500),
	@SteppingDownLocation varchar(500),
	@InternalUrl varchar(300),
	@Heir bit,
	@Picture1Url varchar(300),
	@Picture2Url varchar(300),
	@Picture1Caption nvarchar(1000),
	@Picture2Caption nvarchar(1000),
	@Picture1Credit nvarchar(1000),
	@Picture2Credit nvarchar(1000),
	@Email nvarchar(100),
	@Regent bit
AS

INSERT INTO SCACrowns (
	[GroupId],
	[Reign],
	[SovereignId],
	[ConsortId],
	[Notes],
	[StartDate],
	[EndDate],
	[CoronationLocation],
	[CrownTournamentDate],
	[CrownTournamentLocation],
	[SteppingDownLocation],
	[InternalUrl],
	[Heir],
	[Picture1Url],
	[Picture2Url],
	[Picture1Caption],
	[Picture2Caption],
	[Picture1Credit],
	[Picture2Credit],
	[Email],
	[Regent]
) VALUES (
	@GroupId,
	@Reign,
	@SovereignId,
	@ConsortId,
	@Notes,
	@StartDate,
	@EndDate,
	@CoronationLocation,
	@CrownTournamentDate,
	@CrownTournamentLocation,
	@SteppingDownLocation,
	@InternalUrl,
	@Heir,
	@Picture1Url,
	@Picture2Url,
	@Picture1Caption,
	@Picture2Caption,
	@Picture1Credit,
	@Picture2Credit,
	@Email,
	@Regent
)

select SCOPE_IDENTITY()
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAGroupHistoryUpdate]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroupHistoryUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAGroupHistoryUpdate]
	@GroupHistoryId int, 
	@Date datetime, 
	@FromGroupId int, 
	@ToGroupId int, 
	@Note varchar 
AS

UPDATE SCAGroupHistory SET
	[Date] = @Date,
	[FromGroupId] = @FromGroupId,
	[ToGroupId] = @ToGroupId,
	[Note] = @Note
WHERE
	[GroupHistoryId] = @GroupHistoryId
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAGroupHistoryList]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroupHistoryList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAGroupHistoryList]
AS

SELECT
	[GroupHistoryId],
	[Date],
	[FromGroupId],
	[ToGroupId],
	[Note]
FROM SCAGroupHistory
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAGroupHistoryGetByToGroup]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroupHistoryGetByToGroup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAGroupHistoryGetByToGroup]
	@ToGroupId int
AS

SELECT
	[GroupHistoryId],
	[Date],
	[FromGroupId],
	[ToGroupId],
	[Note]
FROM SCAGroupHistory
WHERE
	[ToGroupId]=@ToGroupId
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAGroupHistoryGetByFromGroup]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroupHistoryGetByFromGroup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAGroupHistoryGetByFromGroup]
	@FromGroupId int
AS

SELECT
	[GroupHistoryId],
	[Date],
	[FromGroupId],
	[ToGroupId],
	[Note]
FROM SCAGroupHistory
WHERE
	[FromGroupId]=@FromGroupId
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAGroupHistoryGet]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroupHistoryGet]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAGroupHistoryGet]
	@GroupHistoryId int
	
AS

SELECT
	[GroupHistoryId],
	[Date],
	[FromGroupId],
	[ToGroupId],
	[Note]
FROM SCAGroupHistory
WHERE
	[GroupHistoryId] = @GroupHistoryId
	
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAGroupHistoryDelete]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroupHistoryDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAGroupHistoryDelete]
	@GroupHistoryId int
AS

DELETE FROM SCAGroupHistory
WHERE
	[GroupHistoryId] = @GroupHistoryId
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAGroupHistoryAdd]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroupHistoryAdd]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAGroupHistoryAdd]
	@Date datetime,
	@FromGroupId int,
	@ToGroupId int,
	@Note varchar
AS

INSERT INTO SCAGroupHistory (
	[Date],
	[FromGroupId],
	[ToGroupId],
	[Note]
) VALUES (
	@Date,
	@FromGroupId,
	@ToGroupId,
	@Note
)

select SCOPE_IDENTITY()
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAOfficerPositionUpdate]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAOfficerPositionUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAOfficerPositionUpdate]
	@OfficerPositionId int, 
	@Title varchar(200), 
	@GroupId int, 
	@ListOrder int,
	@BadgeURL nvarchar(300),
	@OfficeEmail nvarchar(100),
	@LinkedToCrown bit
AS

UPDATE SCAOfficerPosition SET
	[Title] = @Title,
	[GroupId] = @GroupId,
	[ListOrder] = @ListOrder,
	BadgeURL = @BadgeURL,
	OfficeEmail = @OfficeEmail,
	LinkedToCrown = @LinkedToCrown
WHERE
	[OfficerPositionId] = @OfficerPositionId

' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAOfficerPositionListByGroup]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAOfficerPositionListByGroup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAOfficerPositionListByGroup]
	@GroupId int
AS

SELECT
	[OfficerPositionId],
	[Title],
	SCAOfficerPosition.[GroupId],
	[ListOrder],
	case when BadgeFiles.FileName is null then SCAOfficerPosition.BadgeURL else BadgeFiles.Folder + BadgeFiles.FileName end as BadgeURL,
	case when BadgeFiles.Width is null then 0 else BadgeFiles.Width end as BadgeURLWidth,
	case when BadgeFiles.Height is null then 0 else BadgeFiles.Height end as BadgeURLHeight,
	SCAGroups.Name as GroupName,
	SCAGroups.Name + '' '' + Title as GroupOfficerTitle,
	LinkedToCrown,
	case when LinkedToCrown=1 then  ''[R] '' else '''' end + Title  as LinkedTitle
FROM SCAOfficerPosition
JOIN SCAGroups ON SCAOfficerPosition.GroupId = SCAGroups.GroupId
left join Files badgeFiles on SCAOfficerPosition.BadgeURL = ''fileid='' + convert(varchar,badgeFiles.FileID)
Where SCAOfficerPosition.GroupID= @GroupId
ORDER BY  Title' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAOfficerPositionList]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAOfficerPositionList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAOfficerPositionList]
AS

SELECT
	[OfficerPositionId],
	[Title],
	SCAOfficerPosition.[GroupId],
	[ListOrder],
	case when BadgeFiles.FileName is null then SCAOfficerPosition.BadgeURL else BadgeFiles.Folder + BadgeFiles.FileName end as BadgeURL,
	case when BadgeFiles.Width is null then 0 else BadgeFiles.Width end as BadgeURLWidth,
	case when BadgeFiles.Height is null then 0 else BadgeFiles.Height end as BadgeURLHeight,
	SCAGroups.Name as GroupName,
	SCAGroups.Name + '' '' + Title as GroupOfficerTitle,
	OfficeEmail,
	LinkedToCrown
FROM SCAOfficerPosition
JOIN SCAGroups ON SCAOfficerPosition.GroupId = SCAGroups.GroupId
left join Files badgeFiles on SCAOfficerPosition.BadgeURL = ''fileid='' + convert(varchar,badgeFiles.FileID)
ORDER BY SCAGroups.Name, Title' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAOfficerPositionDelete]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAOfficerPositionDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAOfficerPositionDelete]
	@OfficerPositionId int
AS

DELETE FROM SCAOfficerPosition
WHERE
	[OfficerPositionId] = @OfficerPositionId

' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAOfficerPositionAdd]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAOfficerPositionAdd]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAOfficerPositionAdd]
	@Title varchar(200),
	@GroupId int,
	@ListOrder int,
	@BadgeURL nvarchar(300),
	@OfficeEmail nvarchar(100),
	@LinkedToCrown bit
AS

INSERT INTO SCAOfficerPosition (
	[Title],
	[GroupId],
	[ListOrder],
	BadgeURL,
	OfficeEmail,
	LinkedToCrown
) VALUES (
	@Title,
	@GroupId,
	@ListOrder,
	@BadgeURL,
	@OfficeEmail,
	@LinkedToCrown
)

select SCOPE_IDENTITY()
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAGroupsListForReigns]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroupsListForReigns]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAGroupsListForReigns]
AS

WITH GroupTree(GroupId, Name, GroupName, Level, Sort)
AS 
(
SELECT
	SCAGroups.GroupId,
	SCAGroups.Name,
	SCAGroups.Name as GroupName,
	1,
    CONVERT(varchar(max), CONVERT(char(50), SCAGroups.Name) + ''|'')
FROM SCAGroups
where ParentGroupId is null
UNION ALL 
SELECT 
SCAGroups.GroupId,
	SCAGroups.Name,
	SCAGroups.Name as GroupName,
    Level + 1,
CONVERT(varchar(max), Sort + CONVERT(char(50), SCAGroups.Name) + ''|'')
FROM SCAGroups
JOIN GroupTree  ON SCAGroups.ParentGroupId = GroupTree.GroupId
)
SELECT GroupId,
GroupName,
Level,
RTRIM(SUBSTRING(sort, 1, 50)) AS lvl1,
RTRIM(SUBSTRING(sort, 52, 50)) AS lvl2,
RTRIM(SUBSTRING(sort, 103, 50)) AS lvl3,
RTRIM(SUBSTRING(sort, 154, 50)) AS lvl4,
AwardCount = (Select Count(*) from SCACrowns where SCACrowns.GroupId = GroupTree.GroupId) ,
GroupTree.GroupName + '' ('' + Convert(varchar(5), (Select Count(*) from SCACrowns where SCACrowns.GroupId = GroupTree.GroupId and heir=0)) + '') Reigns'' as GroupNameCrownCount
From GroupTree
WHERE (Select Count(*) from SCACrowns where SCACrowns.GroupId = GroupTree.GroupId) >0
Order By Sort


' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAGroupsListForOffices]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroupsListForOffices]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAGroupsListForOffices]
AS

WITH GroupTree(GroupId, Name, GroupName, Level, Sort)
AS 
(
SELECT
	SCAGroups.GroupId,
	SCAGroups.Name,
	SCAGroups.Name as GroupName,
	1,
    CONVERT(varchar(max), CONVERT(char(50), SCAGroups.Name) + ''|'')
FROM SCAGroups
where ParentGroupId is null
UNION ALL 
SELECT 
SCAGroups.GroupId,
	SCAGroups.Name,
	SCAGroups.Name as GroupName,
    Level + 1,
CONVERT(varchar(max), Sort + CONVERT(char(50), SCAGroups.Name) + ''|'')
FROM SCAGroups
JOIN GroupTree  ON SCAGroups.ParentGroupId = GroupTree.GroupId
)
SELECT GroupId,
GroupName,
Level,
RTRIM(SUBSTRING(sort, 1, 50)) AS lvl1,
RTRIM(SUBSTRING(sort, 52, 50)) AS lvl2,
RTRIM(SUBSTRING(sort, 103, 50)) AS lvl3,
RTRIM(SUBSTRING(sort, 154, 50)) AS lvl4,

	OfficeCount = (Select Count(*) from SCAOfficerPosition where SCAOfficerPosition.GroupId = GroupTree.GroupId) ,

	GroupTree.Name + '' ('' + Convert(varchar(5), (Select Count(*) from SCAOfficerPosition where SCAOfficerPosition.GroupId = GroupTree.GroupId))
 + '' Offices)'' as GroupNameOfficeCount

From GroupTree

where (Select Count(*) from SCAOfficerPosition where SCAOfficerPosition.GroupId = GroupTree.GroupId) >0
Order By Sort


' 
END
GO
/****** Object:  Table {databaseOwner}.{objectQualifier}[SCAPeopleOfficer]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleOfficer]') AND type in (N'U'))
BEGIN
CREATE TABLE {databaseOwner}.{objectQualifier}[SCAPeopleOfficer](
	[PeopleOfficerId] [int] IDENTITY(1,1) NOT NULL,
	[PeopleId] [int] NOT NULL,
	[OfficerPositionId] [int] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[CurrentlyHeld] [bit] NOT NULL,
	[Acting] [bit] NOT NULL,
	[Verified] [bit] NOT NULL,
	[PositionSubTitle] [varchar](250) NULL,
	[PositionNotes] [varchar](max) NULL,
	[EmailToUse] [varchar](50) NOT NULL,
	[EmailOverride] [nvarchar](100) NULL,
	[VerifiedNotes] [varchar](max) NULL,
	[LinkedCrownId] [int] NULL,
 CONSTRAINT [PK_SCAPeopleOfficer] PRIMARY KEY NONCLUSTERED 
(
	[PeopleOfficerId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleOfficer]') AND name = N'CX_SCAPeopleOfficer')
CREATE CLUSTERED INDEX [CX_SCAPeopleOfficer] ON {databaseOwner}.{objectQualifier}[SCAPeopleOfficer] 
(
	[PeopleId] ASC,
	[OfficerPositionId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleGet]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleGet]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleGet]
	@PeopleId int
	
AS

SELECT
	PeopleId,
	SCAName,
	MundaneName,
	Address1,
	Address2,
	City,
	State,
	Zip,
	Phone1,
	Phone2,
	EmailAddress,
	case when photoFiles.FileName is null then SCAPeople.PhotoURL else photoFiles.Folder + photoFiles.FileName end as PhotoURL,
	case when photoFiles.Width is null then 0 else photoFiles.Width end as PhotoURLWidth,
	case when photoFiles.Height is null then 0 else photoFiles.Height end as PhotoURLHeight,
	case when armsFiles.FileName is null then SCAPeople.ArmsURL else armsFiles.Folder + armsFiles.FileName end as ArmsURL,
	case when armsFiles.Width is null then 0 else armsFiles.Width end as ArmsURLWidth,
	case when armsFiles.Height is null then 0 else armsFiles.Height end as ArmsURLHeight,
	SCAPeople.ArmsBlazon,
	ShowPicPermission,
	ShowEmailPermission,
	AdminNotes,
	OfficerNotes,
	OPNum,
	Gender,
	[TitlePrefix],
	[HonorsSuffix],
Deceased,
[DeceasedWhen],
[BranchResidenceId],
SCAGroups.Name as BranchResidence
FROM SCAPeople
left join Files photoFiles on SCAPeople.PhotoURL = ''fileid='' + convert(varchar,photoFiles.FileID)
left join Files armsFiles on SCAPeople.ArmsURL = ''fileid='' + convert(varchar,armsFiles.FileID)
left join SCAGroups on SCAPeople.BranchResidenceId = SCAGroups.GroupId
WHERE (PeopleId = @PeopleId)
	
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleList]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleList]
AS

SELECT
	PeopleId,
	SCAName,
	MundaneName,
	Address1,
	Address2,
	City,
	State,
	Zip,
	Phone1,
	Phone2,
	EmailAddress,
	PhotoURL,
	ArmsURL,
	ArmsBlazon,
	ShowPicPermission,
	ShowEmailPermission,
	AdminNotes,
	OfficerNotes,
	OPNum
FROM SCAPeople
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleAdd]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleAdd]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleAdd]
	@SCAName nvarchar(300),
	@MundaneName varchar(300),
	@Address1 nvarchar(100),
	@Address2 nvarchar(100),
	@City nvarchar(100),
	@State nvarchar(50),
	@Zip nvarchar(50),
	@Phone1 nvarchar(50),
	@Phone2 nvarchar(50),
	@EmailAddress nvarchar(100),
	@PhotoURL nvarchar(300),
	@ArmsURL nvarchar(300),
	@ArmsBlazon nvarchar(max),
	@ShowPicPermission bit,
	@ShowEmailPermission bit,
	@AdminNotes varchar(8000),
	@OfficerNotes varchar(1000),
	@Gender char(1),
	@TitlePrefix nvarchar(50),
	@HonorsSuffix nvarchar(50),
	@Deceased bit,
	@DeceasedWhen int,
    @BranchResidenceId int
AS
INSERT INTO SCAPeople (
	[SCAName],
	[MundaneName],
	[Address1],
	[Address2],
	[City],
	[State],
	[Zip],
	[Phone1],
	[Phone2],
	[EmailAddress],
	[PhotoURL],
	[ArmsURL],
	[ArmsBlazon],
	[ShowPicPermission],
	[ShowEmailPermission],
	[AdminNotes],
	[OfficerNotes],
	[Gender],
	[TitlePrefix],
	[HonorsSuffix],
Deceased,
[DeceasedWhen],
[BranchResidenceId]

) VALUES (
	@SCAName,
	@MundaneName,
	@Address1,
	@Address2,
	@City,
	@State,
	@Zip,
	@Phone1,
	@Phone2,
	@EmailAddress,
	@PhotoURL,
	@ArmsURL,
	@ArmsBlazon,
	@ShowPicPermission,
	@ShowEmailPermission,
	@AdminNotes,
	@OfficerNotes,
	@Gender,
	@TitlePrefix,
	@HonorsSuffix,
	@Deceased ,
	@DeceasedWhen ,
    @BranchResidenceId
)
select SCOPE_IDENTITY()
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleUpdate]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleUpdate]
	@PeopleId int, 
	@SCAName nvarchar(300), 
	@MundaneName varchar(300), 
	@Address1 nvarchar(100), 
	@Address2 nvarchar(100), 
	@City nvarchar(100), 
	@State nvarchar(50), 
	@Zip nvarchar(50), 
	@Phone1 nvarchar(50), 
	@Phone2 nvarchar(50), 
	@EmailAddress nvarchar(100), 
	@PhotoURL nvarchar(300), 
	@ArmsURL nvarchar(300), 
	@ArmsBlazon nvarchar(max), 
	@ShowPicPermission bit, 
	@ShowEmailPermission bit, 
	@AdminNotes varchar(8000), 
	@OfficerNotes varchar(1000),
	@Gender char(1),
	@TitlePrefix nvarchar(50),
	@HonorsSuffix nvarchar(50),
	@Deceased bit,
	@DeceasedWhen int,
    @BranchResidenceId int
AS
UPDATE SCAPeople SET
	[SCAName] = @SCAName,
	[MundaneName] = @MundaneName,
	[Address1] = @Address1,
	[Address2] = @Address2,
	[City] = @City,
	[State] = @State,
	[Zip] = @Zip,
	[Phone1] = @Phone1,
	[Phone2] = @Phone2,
	[EmailAddress] = @EmailAddress,
	[PhotoURL] = @PhotoURL,
	[ArmsURL] = @ArmsURL,
	[ArmsBlazon] = @ArmsBlazon,
	[ShowPicPermission] = @ShowPicPermission,
	[ShowEmailPermission] = @ShowEmailPermission,
	[AdminNotes] = @AdminNotes,
	[OfficerNotes] = @OfficerNotes,
	[Gender] = @Gender,
	[TitlePrefix] =@TitlePrefix ,
	[HonorsSuffix]= @HonorsSuffix,
	Deceased = @Deceased,
	[DeceasedWhen] = @DeceasedWhen,
	[BranchResidenceId]   = @BranchResidenceId
WHERE
	[PeopleId] = @PeopleId
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleOfficerListGroupRulers]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleOfficerListGroupRulers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- Stored Procedure

CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleOfficerListGroupRulers]
 @GroupId int,
 @CrownId int
AS

WITH NewFiles(FileName, Width, Height, FileId,Folder, FileJoin) AS
(
Select FileName, Width, Height, FileId, Folder, ''fileid=''+ convert(varchar,FileID)
FROM Files
),
GroupTree(GroupId, Name, GroupName, Level, Sort)
AS 
(
SELECT
	SCAGroups.GroupId,
	SCAGroups.Name,
	SCAGroups.Name as GroupName,
	1,
    CONVERT(varchar(max), CONVERT(char(50), SCAGroups.Name) + ''|'')
FROM SCAGroups
where ParentGroupId is null
UNION ALL 
SELECT 
SCAGroups.GroupId,
	SCAGroups.Name,
	SCAGroups.Name as GroupName,
    Level + 1,
CONVERT(varchar(max), Sort + CONVERT(char(50), SCAGroups.Name) + ''|'')
FROM SCAGroups
JOIN GroupTree  ON SCAGroups.ParentGroupId = GroupTree.GroupId
)

SELECT
	SCACrowns.CrownId as ID,
	SCACrowns.SovereignId AS PeopleId,
	CASE WHEN heir =0  THEN '''' ELSE ''Heir to the '' END + 
	CASE gender WHEN ''M'' THEN SovereignMaleTitle WHEN ''F'' THEN SovereignFemaleTitle ELSE ''Sovereign'' END  
	 AS Title,
	-1 as OfficerPositionId,
   	Cast( null as varchar) as BadgeUrl, --case when SovereignArmsFiles.FileName is null then SCAGroups.SovereignArmsUrl else SovereignArmsFiles.Folder + SovereignArmsFiles.FileName end as BadgeUrl,
	0 as BadgeURLWidth,
	0 as BadgeURLHeight,
	SCAPeople.SCAName,
	MundaneName,
	Address1,
	Address2,
	City,
	State,
	Zip,
	Phone1,
	Phone2,
	EmailAddress,
	case when photoFiles.FileName is null then SCAPeople.PhotoURL else photoFiles.Folder + photoFiles.FileName end as PhotoUrl,
	case when photoFiles.Width is null then 0 else photoFiles.Width end as PhotoURLWidth,
	case when photoFiles.Height is null then 0 else photoFiles.Height end as PhotoURLHeight,
 case when armsFiles.FileName is null then SCAPeople.ArmsURL else armsFiles.Folder + armsFiles.FileName end as ArmsURL,
	case when armsFiles.Width is null then 0 else armsFiles.Width end as ArmsURLWidth,
	case when armsFiles.Height is null then 0 else armsFiles.Height end as ArmsURLHeight,
	OfficerNotes,
	[TitlePrefix],
	[HonorsSuffix],
	SCAGroups.Name AS GroupName,
	SCAGroups.GroupId,
	SCACrowns.StartDate,
	SCACrowns.EndDate,
	CAST( CASE WHEN (GETDATE() BETWEEN SCACrowns.StartDate AND SCACrowns.EndDate) OR (SCACrowns.EndDate is null) THEN 1 ELSE 0 END as bit) AS CurrentlyHeld,
	CAST(0 as bit) as Acting,
	CAST(1 as bit) as Verified,
'''' as PositionSubTitle,
'''' as PositionNotes,
	-1004 as ListOrder,
	GroupTree.GroupName as HomeBranch,
	RTRIM(SUBSTRING(GroupTree.sort, 1, 50)) as HomeKingdom
FROM SCACrowns 
JOIN SCAGroups ON SCACrowns.GroupId = SCAGroups.GroupId 
JOIN SCAPeople ON SCACrowns.SovereignId = SCAPeople.PeopleId
left join NewFiles photoFiles on SCAPeople.PhotoURL =photoFiles.FileJoin
left join NewFiles SovereignArmsFiles on SCAGroups.SovereignArmsUrl = SovereignArmsFiles.FileJoin
left join NewFiles armsFiles on SCAPeople.ArmsURL = armsFiles.FileJoin
LEFT JOIN GroupTree on SCAPeople.BranchResidenceId = GroupTree.GroupId
WHERE (SCACrowns.GroupId = @GroupId) 
and ((@CrownId = -1 AND  SCACrowns.Reign = (SELECT MAX(Reign) 
						FROM SCACrowns wC
						WHERE wC.GroupId = SCAGroups.GroupId and Heir=0) 
						and Heir=0 
						AND ((GETDATE() BETWEEN SCACrowns.StartDate AND SCACrowns.EndDate) OR (SCACrowns.EndDate is null)))
	OR SCACrowns.CrownId = @CrownId)
UNION ALL --Consort Sovereign of Group
SELECT
	SCACrowns.CrownId as ID,
	SCACrowns.ConsortId AS PeopleId,
	CASE WHEN heir =0  THEN '''' ELSE ''Heir to the '' END + 
	CASE gender WHEN ''M'' THEN ConsortMaleTitle WHEN ''F'' THEN ConsortFemaleTitle ELSE ''Consort'' END
	 AS Title,
	-1 as OfficerPositionId,
    Cast( null as varchar) as BadgeUrl, --case when ConsortArmsFiles.FileName is null then SCAGroups.ConsortArmsUrl else ConsortArmsFiles.Folder + ConsortArmsFiles.FileName end as BadgeUrl,
	0 as BadgeURLWidth,
	0 as BadgeURLHeight,
	SCAPeople.SCAName,
	MundaneName,
	Address1,
	Address2,
	City,
	State,
	Zip,
	Phone1,
	Phone2,
	EmailAddress,
	case when photoFiles.FileName is null then SCAPeople.PhotoURL else photoFiles.Folder + photoFiles.FileName end as PhotoUrl,
	case when photoFiles.Width is null then 0 else photoFiles.Width end as PhotoURLWidth,
	case when photoFiles.Height is null then 0 else photoFiles.Height end as PhotoURLHeight,
 case when armsFiles.FileName is null then SCAPeople.ArmsURL else armsFiles.Folder + armsFiles.FileName end as ArmsURL,
	case when armsFiles.Width is null then 0 else armsFiles.Width end as ArmsURLWidth,
	case when armsFiles.Height is null then 0 else armsFiles.Height end as ArmsURLHeight,
	OfficerNotes,
	[TitlePrefix],
	[HonorsSuffix],
	SCAGroups.Name AS GroupName,
	SCAGroups.GroupId,
	SCACrowns.StartDate,
	SCACrowns.EndDate,
	CAST( CASE WHEN (GETDATE() BETWEEN SCACrowns.StartDate AND SCACrowns.EndDate) OR (SCACrowns.EndDate is null) THEN 1 ELSE 0 END as bit) AS CurrentlyHeld,
	CAST(0 as bit) as Acting,
	CAST(1 as bit) as Verified,
'''' as PositionSubTitle,
'''' as PositionNotes,
	-1003 as ListOrder,
	GroupTree.GroupName as HomeBranch,
	RTRIM(SUBSTRING(GroupTree.sort, 1, 50)) as HomeKingdom
FROM SCACrowns 
JOIN SCAGroups ON SCACrowns.GroupId = SCAGroups.GroupId 
JOIN SCAPeople ON SCACrowns.Consortid = SCAPeople.PeopleId
left join NewFiles photoFiles on SCAPeople.PhotoURL =photoFiles.FileJoin
left join NewFiles ConsortArmsFiles on SCAGroups.ConsortArmsUrl = ConsortArmsFiles.FileJoin
left join NewFiles armsFiles on SCAPeople.ArmsURL = armsFiles.FileJoin
LEFT JOIN GroupTree on SCAPeople.BranchResidenceId = GroupTree.GroupId
WHERE (SCACrowns.GroupId = @GroupId) 
and ((@CrownId = -1 AND  SCACrowns.Reign = (SELECT MAX(Reign) 
						FROM SCACrowns wC
						WHERE wC.GroupId = SCAGroups.GroupId and Heir=0) 
						and Heir=0 
						AND ((GETDATE() BETWEEN SCACrowns.StartDate AND SCACrowns.EndDate) OR (SCACrowns.EndDate is null)))
	OR SCACrowns.CrownId = @CrownId)
UNION ALL  -- Heir to Soveren
SELECT
	SCACrowns.CrownId as ID,
	SCACrowns.SovereignId AS PeopleId,
	CASE WHEN heir =0  THEN '''' ELSE ''Heir to the '' END + 
	CASE gender WHEN ''M'' THEN SovereignMaleTitle WHEN ''F'' THEN SovereignFemaleTitle ELSE ''Sovereign'' END  
	 AS Title,
	-1 as OfficerPositionId,
	Cast( null as varchar) as BadgeUrl, --case when SovereignArmsFiles.FileName is null then SCAGroups.SovereignArmsUrl else SovereignArmsFiles.Folder + SovereignArmsFiles.FileName end as BadgeUrl,
	0 as BadgeURLWidth,
	0 as BadgeURLHeight,
	SCAPeople.SCAName,
	MundaneName,
	Address1,
	Address2,
	City,
	State,
	Zip,
	Phone1,
	Phone2,
	EmailAddress,
	case when photoFiles.FileName is null then SCAPeople.PhotoURL else photoFiles.Folder + photoFiles.FileName end as PhotoURL,
	case when photoFiles.Width is null then 0 else photoFiles.Width end as PhotoURLWidth,
	case when photoFiles.Height is null then 0 else photoFiles.Height end as PhotoURLHeight,
 case when armsFiles.FileName is null then SCAPeople.ArmsURL else armsFiles.Folder + armsFiles.FileName end as ArmsURL,
	case when armsFiles.Width is null then 0 else armsFiles.Width end as ArmsURLWidth,
	case when armsFiles.Height is null then 0 else armsFiles.Height end as ArmsURLHeight,
	OfficerNotes,
	[TitlePrefix],
	[HonorsSuffix],
	SCAGroups.Name AS GroupName,
	SCAGroups.GroupId,
	SCACrowns.StartDate,
	SCACrowns.EndDate,
	CAST( CASE WHEN (GETDATE() BETWEEN SCACrowns.StartDate AND SCACrowns.EndDate) OR (SCACrowns.EndDate is null) THEN 1 ELSE 0 END as bit) AS CurrentlyHeld,
	CAST(0 as bit) as Acting,
	CAST(1 as bit) as Verified,
'''' as PositionSubTitle,
'''' as PositionNotes,
	-1002 as ListOrder,
	GroupTree.GroupName as HomeBranch,
	RTRIM(SUBSTRING(GroupTree.sort, 1, 50)) as HomeKingdom
FROM SCACrowns 
JOIN SCAGroups ON SCACrowns.GroupId = SCAGroups.GroupId 
JOIN SCAPeople ON SCACrowns.SovereignId = SCAPeople.PeopleId
left join NewFiles photoFiles on SCAPeople.PhotoURL =photoFiles.FileJoin
left join NewFiles SovereignArmsFiles on SCAGroups.SovereignArmsUrl = SovereignArmsFiles.FileJoin
left join NewFiles armsFiles on SCAPeople.ArmsURL = armsFiles.FileJoin
LEFT JOIN GroupTree on SCAPeople.BranchResidenceId = GroupTree.GroupId
WHERE (SCACrowns.GroupId = @GroupId) 
		and (@CrownId = -1 AND SCACrowns.Reign = (SELECT MAX(Reign) 
								FROM SCACrowns wC
								WHERE wC.GroupId = SCAGroups.GroupId and Heir=1) 
								and Heir=1 AND ((GETDATE() BETWEEN SCACrowns.StartDate AND SCACrowns.EndDate) OR (SCACrowns.EndDate is null)))
UNION ALL -- heir to consort
SELECT
	SCACrowns.CrownId as ID,
	SCACrowns.ConsortId AS PeopleId,
	CASE WHEN heir =0  THEN '''' ELSE ''Heir to the '' END + 
	CASE gender WHEN ''M'' THEN ConsortMaleTitle WHEN ''F'' THEN ConsortFemaleTitle ELSE ''Consort'' END
	 AS Title,
	-1 as OfficerPositionId,
    Cast( null as varchar) as BadgeUrl, --case when ConsortArmsFiles.FileName is null then SCAGroups.ConsortArmsUrl else ConsortArmsFiles.Folder + ConsortArmsFiles.FileName end as BadgeUrl,
	0 as BadgeURLWidth,
	0 as BadgeURLHeight,
	SCAPeople.SCAName,
	MundaneName,
	Address1,
	Address2,
	City,
	State,
	Zip,
	Phone1,
	Phone2,
	EmailAddress,
	case when photoFiles.FileName is null then SCAPeople.PhotoURL else photoFiles.Folder + photoFiles.FileName end as PhotoURL,
	case when photoFiles.Width is null then 0 else photoFiles.Width end as PhotoURLWidth,
	case when photoFiles.Height is null then 0 else photoFiles.Height end as PhotoURLHeight,
 case when armsFiles.FileName is null then SCAPeople.ArmsURL else armsFiles.Folder + armsFiles.FileName end as ArmsURL,
	case when armsFiles.Width is null then 0 else armsFiles.Width end as ArmsURLWidth,
	case when armsFiles.Height is null then 0 else armsFiles.Height end as ArmsURLHeight,
	OfficerNotes,
	[TitlePrefix],
	[HonorsSuffix],
	SCAGroups.Name AS GroupName,
	SCAGroups.GroupId,
	SCACrowns.StartDate,
	SCACrowns.EndDate,
	CAST( CASE WHEN (GETDATE() BETWEEN SCACrowns.StartDate AND SCACrowns.EndDate) OR (SCACrowns.EndDate is null) THEN 1 ELSE 0 END as bit) AS CurrentlyHeld,
	CAST(0 as bit) as Acting,
	CAST(1 as bit) as Verified,
'''' as PositionSubTitle,
'''' as PositionNotes,
	-1001 as ListOrder,
	GroupTree.GroupName as HomeBranch,
	RTRIM(SUBSTRING(GroupTree.sort, 1, 50)) as HomeKingdom
FROM SCACrowns 
JOIN SCAGroups ON SCACrowns.GroupId = SCAGroups.GroupId 
JOIN SCAPeople ON SCACrowns.Consortid = SCAPeople.PeopleId
left join NewFiles photoFiles on SCAPeople.PhotoURL =photoFiles.FileJoin
left join NewFiles ConsortArmsFiles on SCAGroups.ConsortArmsUrl = ConsortArmsFiles.FileJoin
left join NewFiles armsFiles on SCAPeople.ArmsURL = armsFiles.FileJoin
LEFT JOIN GroupTree on SCAPeople.BranchResidenceId = GroupTree.GroupId
WHERE (SCACrowns.GroupId = @GroupId) 
				and (@CrownId = -1 AND SCACrowns.Reign = (SELECT MAX(Reign) 
								FROM SCACrowns wC
								WHERE wC.GroupId = SCAGroups.GroupId and Heir=1) 
								and Heir=1 AND ((GETDATE() BETWEEN SCACrowns.StartDate AND SCACrowns.EndDate) OR (SCACrowns.EndDate is null)))
Order By ListOrder ASC, SCAName ASC
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleOfficerListGroupRegnum]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleOfficerListGroupRegnum]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleOfficerListGroupRegnum]
 @GroupId int
AS
WITH NewFiles(FileName, Width, Height, FileId,Folder, FileJoin) AS
(
Select FileName, Width, Height, FileId, Folder, ''fileid=''+ convert(varchar,FileID)
FROM Files
)

SELECT
	SCAPeopleOfficer.PeopleOfficerId as ID,
	SCAPeopleOfficer.PeopleId,
	SCAOfficerPosition.Title,
	SCAOfficerPosition.OfficerPositionId,
    case when BadgeFiles.FileName is null then SCAOfficerPosition.BadgeURL else BadgeFiles.Folder + BadgeFiles.FileName end as BadgeURL,
	case when BadgeFiles.Width is null then 0 else BadgeFiles.Width end as BadgeURLWidth,
	case when BadgeFiles.Height is null then 0 else BadgeFiles.Height end as BadgeURLHeight,
	IsNull(SCAPeople.SCAName, ''VACANT'') as SCAName,
	SCAPeople.MundaneName,
	SCAPeople.Address1,
	SCAPeople.Address2,
	SCAPeople.City,
	SCAPeople.State,
	SCAPeople.Zip,
	SCAPeople.Phone1,
	SCAPeople.Phone2,
	SCAPeople.EmailAddress,
	SCAOfficerPosition.OfficeEmail,
	SCAPeopleOfficer.EmailToUse,
	SCAPeopleOfficer.EmailOverride,
	SCAOfficerPosition.LinkedToCrown,
	case when photoFiles.FileName is null then SCAPeople.PhotoURL else photoFiles.Folder + photoFiles.FileName end as PhotoUrl,
	case when photoFiles.Width is null then 0 else photoFiles.Width end as PhotoURLWidth,
	case when photoFiles.Height is null then 0 else photoFiles.Height end as PhotoURLHeight,
    case when armsFiles.FileName is null then SCAPeople.ArmsURL else armsFiles.Folder + armsFiles.FileName end as ArmsURL,
	case when armsFiles.Width is null then 0 else armsFiles.Width end as ArmsURLWidth,
	case when armsFiles.Height is null then 0 else armsFiles.Height end as ArmsURLHeight,
	SCAPeople.OfficerNotes,
	SCAPeople.[TitlePrefix],
	SCAPeople.[HonorsSuffix],
	SCAGroups.Name AS GroupName,
	SCAGroups.GroupId,
	SCAPeopleOfficer.StartDate,
	SCAPeopleOfficer.EndDate,
	SCAPeopleOfficer.CurrentlyHeld,
	IsNull(SCAPeopleOfficer.Acting, 0) as Acting,
	SCAPeopleOfficer.Verified,
	SCAPeopleOfficer.PositionSubTitle,
	SCAPeopleOfficer.PositionNotes,
	SCAPeopleOfficer.VerifiedNotes,
	SCAOfficerPosition.ListOrder,
	LinkedCrownId,
			CASE 
				WHEN LEFT(Sovereign.SCAName, CASE WHEN PATINDEX(''% %'',Sovereign.SCAName)>0 THEN PATINDEX(''% %'',Sovereign.SCAName) -1 ELSE 0 END) = '''' THEN Sovereign.SCAName 
				ELSE LEFT(Sovereign.SCAName, CASE WHEN PATINDEX(''% %'',Sovereign.SCAName)>0 THEN PATINDEX(''% %'',Sovereign.SCAName) -1 ELSE 0 END) END + 
			CASE 
				WHEN Consort.SCAName IS NULL THEN '''' 
				ELSE '' and '' END + 
			CASE 
				WHEN Consort.SCAName IS NULL THEN ''''  
				WHEN LEFT(Consort.SCAName,CASE WHEN PATINDEX(''% %'',Consort.SCAName)>0 THEN PATINDEX(''% %'',Consort.SCAName) -1 ELSE 0 END) = '''' THEN Consort.SCAName 
				ELSE LEFT(Consort.SCAName,CASE WHEN PATINDEX(''% %'',Consort.SCAName)>0 THEN PATINDEX(''% %'',Consort.SCAName) -1 ELSE 0 END) END 
	AS LinkedCrownDisplay
FROM SCAOfficerPosition
LEFT JOIN  SCAPeopleOfficer ON SCAPeopleOfficer.OfficerPositionId = SCAOfficerPosition.OfficerPositionId AND
	(
		(GETDATE() between SCAPeopleOfficer.StartDate and SCAPeopleOfficer.EndDate) OR -- Current date is between start and end
		(GETDATE() > SCAPeopleOfficer.StartDate and SCAPeopleOfficer.CurrentlyHeld=1)  -- Current date after start and currentlyheld is marked.
	)
LEFT JOIN SCAGroups ON SCAOfficerPosition.GroupId = SCAGroups.GroupId
LEFT JOIN SCAPeople on SCAPeopleOfficer.PeopleId = SCAPeople.PeopleId
left join NewFiles photoFiles on SCAPeople.PhotoURL = photoFiles.FileJoin
left join NewFiles badgeFiles on SCAOfficerPosition.BadgeURL = badgeFiles.FileJoin
left join NewFiles armsFiles on SCAPeople.ArmsURL = armsFiles.FileJoin
left join SCACrowns on SCAPeopleOfficer.LinkedCrownId = SCACrowns.CrownId
LEFT JOIN SCAPeople Consort ON SCACrowns.ConsortId = Consort.PeopleId
LEFT JOIN SCAPeople Sovereign ON SCACrowns.SovereignId = Sovereign.PeopleId
WHERE (SCAOfficerPosition.GroupId = @GroupId)
UNION ALL -- Soveriern of Group
SELECT
	SCACrowns.CrownId as ID,
	SCACrowns.SovereignId AS PeopleId,
	CASE WHEN heir =0  THEN '''' ELSE ''Heir to the '' END + 
	CASE gender WHEN ''M'' THEN SovereignMaleTitle WHEN ''F'' THEN SovereignFemaleTitle ELSE ''Sovereign'' END  
	 AS Title,
	''-1'' as OfficerPositionId,
   	null as BadgeUrl, --case when SovereignArmsFiles.FileName is null then SCAGroups.SovereignArmsUrl else SovereignArmsFiles.Folder + SovereignArmsFiles.FileName end as BadgeUrl,
	case when SovereignArmsFiles.Width is null then 0 else SovereignArmsFiles.Width end as BadgeWidth,
	case when SovereignArmsFiles.Height is null then 0 else SovereignArmsFiles.Height end as BadgeHeight,
	SCAPeople.SCAName,
	MundaneName,
	Address1,
	Address2,
	City,
	State,
	Zip,
	Phone1,
	Phone2,
	EmailAddress,
	SCACrowns.Email,
	'''' as EmailToUse,
	'''' as EmailOverride,
	Cast(0 as bit) as LinkedToCrown,
	case when photoFiles.FileName is null then SCAPeople.PhotoURL else photoFiles.Folder + photoFiles.FileName end as PhotoUrl,
	case when photoFiles.Width is null then 0 else photoFiles.Width end as PhotoURLWidth,
	case when photoFiles.Height is null then 0 else photoFiles.Height end as PhotoURLHeight,
	case when armsFiles.FileName is null then SCAPeople.ArmsURL else armsFiles.Folder + armsFiles.FileName end as ArmsURL,
	case when armsFiles.Width is null then 0 else armsFiles.Width end as ArmsURLWidth,
	case when armsFiles.Height is null then 0 else armsFiles.Height end as ArmsURLHeight,
	OfficerNotes,
	[TitlePrefix],
	[HonorsSuffix],
	SCAGroups.Name AS GroupName,
	SCAGroups.GroupId,
	SCACrowns.StartDate,
	SCACrowns.EndDate,
	CASE WHEN (GETDATE() BETWEEN SCACrowns.StartDate AND SCACrowns.EndDate) OR (SCACrowns.EndDate is null) THEN 1 ELSE 0 END AS CurrentlyHeld,
	0 as Acting,
	1 as Verified,
	'''' as PositionSubTitle,
	'''' as PositionNotes,
	'''' as VerifiedNotes,
	-1004 as ListOrder,
	Null as LinkedCrownId, 
	Null As LinkedCrownDisplay
FROM SCACrowns 
JOIN SCAGroups ON SCACrowns.GroupId = SCAGroups.GroupId 
JOIN SCAPeople ON SCACrowns.SovereignId = SCAPeople.PeopleId
left join NewFiles photoFiles on SCAPeople.PhotoURL =photoFiles.FileJoin
left join NewFiles SovereignArmsFiles on SCAGroups.SovereignArmsUrl = SovereignArmsFiles.FileJoin
left join NewFiles armsFiles on SCAPeople.ArmsURL = armsFiles.FileJoin
WHERE (SCACrowns.GroupId = @GroupId) and SCACrowns.Reign = (SELECT
	MAX(Reign) 
FROM SCACrowns wC
WHERE wC.GroupId = SCAGroups.GroupId and Heir=0) and Heir=0 AND ((GETDATE() BETWEEN SCACrowns.StartDate AND SCACrowns.EndDate) OR (SCACrowns.EndDate is null))

UNION ALL --Consort Sovereign of Group

SELECT
	SCACrowns.CrownId as ID,
	SCACrowns.ConsortId AS PeopleId,
	CASE WHEN heir =0  THEN '''' ELSE ''Heir to the '' END + 
	CASE gender WHEN ''M'' THEN ConsortMaleTitle WHEN ''F'' THEN ConsortFemaleTitle ELSE ''Consort'' END
	 AS Title,
	''-1'' as OfficerPositionId,
    null as BadgeUrl, --case when ConsortArmsFiles.FileName is null then SCAGroups.ConsortArmsUrl else ConsortArmsFiles.Folder + ConsortArmsFiles.FileName end as BadgeUrl,
	case when ConsortArmsFiles.Width is null then 0 else ConsortArmsFiles.Width end as BadgeWidth,
	case when ConsortArmsFiles.Height is null then 0 else ConsortArmsFiles.Height end as BadgeHeight,
	SCAPeople.SCAName,
	MundaneName,
	Address1,
	Address2,
	City,
	State,
	Zip,
	Phone1,
	Phone2,
	EmailAddress,
	SCACrowns.Email,
	'''' as EmailToUse,
	'''' as EmailOverride,
	Cast(0 as bit) as LinkedToCrown,
	case when photoFiles.FileName is null then SCAPeople.PhotoURL else photoFiles.Folder + photoFiles.FileName end as PhotoUrl,
	case when photoFiles.Width is null then 0 else photoFiles.Width end as PhotoURLWidth,
	case when photoFiles.Height is null then 0 else photoFiles.Height end as PhotoURLHeight,
	case when armsFiles.FileName is null then SCAPeople.ArmsURL else armsFiles.Folder + armsFiles.FileName end as ArmsURL,
	case when armsFiles.Width is null then 0 else armsFiles.Width end as ArmsURLWidth,
	case when armsFiles.Height is null then 0 else armsFiles.Height end as ArmsURLHeight,
	OfficerNotes,
	[TitlePrefix],
	[HonorsSuffix],
	SCAGroups.Name AS GroupName,
	SCAGroups.GroupId,
	SCACrowns.StartDate,
	SCACrowns.EndDate,
	CASE WHEN (GETDATE() BETWEEN SCACrowns.StartDate AND SCACrowns.EndDate) OR (SCACrowns.EndDate is null) THEN 1 ELSE 0 END AS CurrentlyHeld,
	0 as Acting,
	1 as Verified,
	'''' as PositionSubTitle,
	'''' as PositionNotes,
	'''' as VerifiedNotes,
	-1003 as ListOrder,
	Null as LinkedCrownId, 
	Null As LinkedCrownDisplay
FROM SCACrowns 
JOIN SCAGroups ON SCACrowns.GroupId = SCAGroups.GroupId 
JOIN SCAPeople ON SCACrowns.Consortid = SCAPeople.PeopleId
left join NewFiles photoFiles on SCAPeople.PhotoURL =photoFiles.FileJoin
left join NewFiles ConsortArmsFiles on SCAGroups.ConsortArmsUrl = ConsortArmsFiles.FileJoin
left join NewFiles armsFiles on SCAPeople.ArmsURL = armsFiles.FileJoin
WHERE (SCACrowns.GroupId = @GroupId) and SCACrowns.Reign = (SELECT
	MAX(Reign)
FROM SCACrowns wC
WHERE wC.GroupId = SCAGroups.GroupId and Heir=0) and Heir=0 AND ((GETDATE() BETWEEN SCACrowns.StartDate AND SCACrowns.EndDate) OR (SCACrowns.EndDate is null))

UNION ALL  -- Heir to Soveren

SELECT
	SCACrowns.CrownId as ID,
	SCACrowns.SovereignId AS PeopleId,
	CASE WHEN heir =0  THEN '''' ELSE ''Heir to the '' END + 
	CASE gender WHEN ''M'' THEN SovereignMaleTitle WHEN ''F'' THEN SovereignFemaleTitle ELSE ''Sovereign'' END  
	 AS Title,
	''-1'' as OfficerPositionId,
   	null as BadgeUrl, --case when SovereignArmsFiles.FileName is null then SCAGroups.SovereignArmsUrl else SovereignArmsFiles.Folder + SovereignArmsFiles.FileName end as BadgeUrl,
	case when SovereignArmsFiles.Width is null then 0 else SovereignArmsFiles.Width end as BadgeWidth,
	case when SovereignArmsFiles.Height is null then 0 else SovereignArmsFiles.Height end as BadgeHeight,
	SCAPeople.SCAName,
	MundaneName,
	Address1,
	Address2,
	City,
	State,
	Zip,
	Phone1,
	Phone2,
	EmailAddress,
	SCACrowns.Email,
	'''' as EmailToUse,
	'''' as EmailOverride,
	Cast(0 as bit) as LinkedToCrown,
	case when photoFiles.FileName is null then SCAPeople.PhotoURL else photoFiles.Folder + photoFiles.FileName end as PhotoUrl,
	case when photoFiles.Width is null then 0 else photoFiles.Width end as PhotoURLWidth,
	case when photoFiles.Height is null then 0 else photoFiles.Height end as PhotoURLHeight,
	case when armsFiles.FileName is null then SCAPeople.ArmsURL else armsFiles.Folder + armsFiles.FileName end as ArmsURL,
	case when armsFiles.Width is null then 0 else armsFiles.Width end as ArmsURLWidth,
	case when armsFiles.Height is null then 0 else armsFiles.Height end as ArmsURLHeight,
	OfficerNotes,
	[TitlePrefix],
	[HonorsSuffix],
	SCAGroups.Name AS GroupName,
	SCAGroups.GroupId,
	SCACrowns.StartDate,
	SCACrowns.EndDate,
	CASE WHEN (GETDATE() BETWEEN SCACrowns.StartDate AND SCACrowns.EndDate) OR (SCACrowns.EndDate is null) THEN 1 ELSE 0 END AS CurrentlyHeld,
	0 as Acting,
	1 as Verified,
	'''' as PositionSubTitle,
	'''' as PositionNotes,
	'''' as VerifiedNotes,
	-1002 as ListOrder,
	Null as LinkedCrownId, 
	Null As LinkedCrownDisplay
FROM SCACrowns 
JOIN SCAGroups ON SCACrowns.GroupId = SCAGroups.GroupId 
JOIN SCAPeople ON SCACrowns.SovereignId = SCAPeople.PeopleId
left join NewFiles photoFiles on SCAPeople.PhotoURL =photoFiles.FileJoin
left join NewFiles SovereignArmsFiles on SCAGroups.SovereignArmsUrl = SovereignArmsFiles.FileJoin
left join NewFiles armsFiles on SCAPeople.ArmsURL = armsFiles.FileJoin
WHERE (SCACrowns.GroupId = @GroupId) and SCACrowns.Reign = (SELECT
	MAX(Reign) 
FROM SCACrowns wC
WHERE wC.GroupId = SCAGroups.GroupId and Heir=1) and Heir=1 AND ((GETDATE() BETWEEN SCACrowns.StartDate AND SCACrowns.EndDate) OR (SCACrowns.EndDate is null))

UNION ALL -- heir to consort

SELECT
	SCACrowns.CrownId as ID,
	SCACrowns.ConsortId AS PeopleId,
	CASE WHEN heir =0  THEN '''' ELSE ''Heir to the '' END + 
	CASE gender WHEN ''M'' THEN ConsortMaleTitle WHEN ''F'' THEN ConsortFemaleTitle ELSE ''Consort'' END
	 AS Title,
	''-1'' as OfficerPositionId,
    null as BadgeUrl, --case when ConsortArmsFiles.FileName is null then SCAGroups.ConsortArmsUrl else ConsortArmsFiles.Folder + ConsortArmsFiles.FileName end as BadgeUrl,
	case when ConsortArmsFiles.Width is null then 0 else ConsortArmsFiles.Width end as BadgeWidth,
	case when ConsortArmsFiles.Height is null then 0 else ConsortArmsFiles.Height end as BadgeHeight,
	SCAPeople.SCAName,
	MundaneName,
	Address1,
	Address2,
	City,
	State,
	Zip,
	Phone1,
	Phone2,
	EmailAddress,
	SCACrowns.Email,
	'''' as EmailToUse,
	'''' as EmailOverride,
	Cast(0 as bit) as LinkedToCrown,
	case when photoFiles.FileName is null then SCAPeople.PhotoURL else photoFiles.Folder + photoFiles.FileName end as PhotoUrl,
	case when photoFiles.Width is null then 0 else photoFiles.Width end as PhotoURLWidth,
	case when photoFiles.Height is null then 0 else photoFiles.Height end as PhotoURLHeight,
	case when armsFiles.FileName is null then SCAPeople.ArmsURL else armsFiles.Folder + armsFiles.FileName end as ArmsURL,
	case when armsFiles.Width is null then 0 else armsFiles.Width end as ArmsURLWidth,
	case when armsFiles.Height is null then 0 else armsFiles.Height end as ArmsURLHeight,
	OfficerNotes,
	[TitlePrefix],
	[HonorsSuffix],
	SCAGroups.Name AS GroupName,
	SCAGroups.GroupId,
	SCACrowns.StartDate,
	SCACrowns.EndDate,
	CASE WHEN (GETDATE() BETWEEN SCACrowns.StartDate AND SCACrowns.EndDate) OR (SCACrowns.EndDate is null) THEN 1 ELSE 0 END AS CurrentlyHeld,
	0 as Acting,
	1 as Verified,
	'''' as PositionSubTitle,
	'''' as PositionNotes,
	'''' as VerifiedNotes,
	-1001 as ListOrder,
	Null as LinkedCrownId, 
	Null As LinkedCrownDisplay
FROM SCACrowns 
JOIN SCAGroups ON SCACrowns.GroupId = SCAGroups.GroupId 
JOIN SCAPeople ON SCACrowns.Consortid = SCAPeople.PeopleId
left join NewFiles photoFiles on SCAPeople.PhotoURL =photoFiles.FileJoin
left join NewFiles ConsortArmsFiles on SCAGroups.ConsortArmsUrl = ConsortArmsFiles.FileJoin
left join NewFiles armsFiles on SCAPeople.ArmsURL = armsFiles.FileJoin
WHERE (SCACrowns.GroupId = @GroupId) and SCACrowns.Reign = (SELECT
	MAX(Reign)
FROM SCACrowns wC
WHERE wC.GroupId = SCAGroups.GroupId and Heir=1) and Heir=1 AND ((GETDATE() BETWEEN SCACrowns.StartDate AND SCACrowns.EndDate) OR (SCACrowns.EndDate is null))
Order By ListOrder ASC, SCAName ASC' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleOfficerListByOfficerPositionIDs]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleOfficerListByOfficerPositionIDs]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleOfficerListByOfficerPositionIDs]
 @OfficerPositionIds varchar(max),
 @ShowVacant bit,
 @ShowHistory bit,
 @UseCrownLink bit,
 @CrownId int
AS

WITH NewFiles(FileName, Width, Height, FileId,Folder, FileJoin) AS
(
Select FileName, Width, Height, FileId, Folder, ''fileid='' + convert(varchar,FileID)
FROM Files
),
GroupTree(GroupId, Name, GroupName, Level, Sort)
AS 
(
SELECT
	SCAGroups.GroupId,
	SCAGroups.Name,
	SCAGroups.Name as GroupName,
	1,
    CONVERT(varchar(max), CONVERT(char(50), SCAGroups.Name) + ''|'')
FROM SCAGroups
where ParentGroupId is null
UNION ALL 
SELECT 
SCAGroups.GroupId,
	SCAGroups.Name,
	SCAGroups.Name as GroupName,
    Level + 1,
CONVERT(varchar(max), Sort + CONVERT(char(50), SCAGroups.Name) + ''|'')
FROM SCAGroups
JOIN GroupTree  ON SCAGroups.ParentGroupId = GroupTree.GroupId
)

 
SELECT
	SCAPeopleOfficer.PeopleOfficerId as ID,
	SCAPeopleOfficer.PeopleId,
	SCAOfficerPosition.Title,
	SCAOfficerPosition.OfficerPositionId,
    case when BadgeFiles.FileName is null then SCAOfficerPosition.BadgeURL else BadgeFiles.Folder + BadgeFiles.FileName end as BadgeURL,
	case when BadgeFiles.Width is null then 0 else BadgeFiles.Width end as BadgeURLWidth,
	case when BadgeFiles.Height is null then 0 else BadgeFiles.Height end as BadgeURLHeight,
	IsNull(SCAPeople.SCAName, ''VACANT'') as SCAName,
	SCAPeople.MundaneName,
	SCAPeople.Address1,
	SCAPeople.Address2,
	SCAPeople.City,
	SCAPeople.State,
	SCAPeople.Zip,
	SCAPeople.Phone1,
	SCAPeople.Phone2,
	SCAPeople.EmailAddress,
	SCAOfficerPosition.OfficeEmail,
	SCAPeopleOfficer.EmailToUse,
	SCAPeopleOfficer.EmailOverride,
	SCAOfficerPosition.LinkedToCrown,
	case when photoFiles.FileName is null then SCAPeople.PhotoURL else photoFiles.Folder + photoFiles.FileName end as PhotoUrl,
	case when photoFiles.Width is null then 0 else photoFiles.Width end as PhotoURLWidth,
	case when photoFiles.Height is null then 0 else photoFiles.Height end as PhotoURLHeight,
    case when armsFiles.FileName is null then SCAPeople.ArmsURL else armsFiles.Folder + armsFiles.FileName end as ArmsURL,
	case when armsFiles.Width is null then 0 else armsFiles.Width end as ArmsURLWidth,
	case when armsFiles.Height is null then 0 else armsFiles.Height end as ArmsURLHeight,
	SCAPeople.OfficerNotes,
	SCAPeople.[TitlePrefix],
	SCAPeople.[HonorsSuffix],
	SCAGroups.Name AS GroupName,
	SCAGroups.GroupId,
	SCAPeopleOfficer.StartDate,
	SCAPeopleOfficer.EndDate,
	SCAPeopleOfficer.CurrentlyHeld,
	IsNull(SCAPeopleOfficer.Acting, 0) as Acting,
	SCAPeopleOfficer.Verified,
	SCAPeopleOfficer.PositionSubTitle,
	SCAPeopleOfficer.PositionNotes,
	SCAPeopleOfficer.VerifiedNotes,
	SCAOfficerPosition.ListOrder,
	GroupTree.GroupName as HomeBranch,
	RTRIM(SUBSTRING(GroupTree.sort, 1, 50)) as HomeKingdom,
	LinkedCrownId,
			CASE 
				WHEN LEFT(Sovereign.SCAName, CASE WHEN PATINDEX(''% %'',Sovereign.SCAName)>0 THEN PATINDEX(''% %'',Sovereign.SCAName) -1 ELSE 0 END) = '''' THEN Sovereign.SCAName 
				ELSE LEFT(Sovereign.SCAName, CASE WHEN PATINDEX(''% %'',Sovereign.SCAName)>0 THEN PATINDEX(''% %'',Sovereign.SCAName) -1 ELSE 0 END) END + 
			CASE 
				WHEN Consort.SCAName IS NULL THEN '''' 
				ELSE '' and '' END + 
			CASE 
				WHEN Consort.SCAName IS NULL THEN ''''  
				WHEN LEFT(Consort.SCAName,CASE WHEN PATINDEX(''% %'',Consort.SCAName)>0 THEN PATINDEX(''% %'',Consort.SCAName) -1 ELSE 0 END) = '''' THEN Consort.SCAName 
				ELSE LEFT(Consort.SCAName,CASE WHEN PATINDEX(''% %'',Consort.SCAName)>0 THEN PATINDEX(''% %'',Consort.SCAName) -1 ELSE 0 END) END 
	AS LinkedCrownDisplay
FROM SCAOfficerPosition
LEFT JOIN  SCAPeopleOfficer ON SCAPeopleOfficer.OfficerPositionId = SCAOfficerPosition.OfficerPositionId AND
	(@ShowVacant = 1 OR SCAPeopleOfficer.OfficerPositionId = SCAOfficerPosition.OfficerPositionId) AND
	(
		(@UseCrownLink=0 and GETDATE() between SCAPeopleOfficer.StartDate and SCAPeopleOfficer.EndDate) OR -- Current date is between start and end
		(@UseCrownLink=0 and GETDATE() > SCAPeopleOfficer.StartDate and SCAPeopleOfficer.CurrentlyHeld=1) OR -- Current date after start and currentlyheld is marked.
		(@UseCrownLink=0 and @ShowHistory=1) OR -- just show them all
		(@UseCrownLink=1 and SCAPeopleOfficer.LinkedCrownId= @CrownId)
	)
LEFT JOIN SCAGroups ON SCAOfficerPosition.GroupId = SCAGroups.GroupId
LEFT JOIN SCAPeople on SCAPeopleOfficer.PeopleId = SCAPeople.PeopleId
left join NewFiles photoFiles on SCAPeople.PhotoURL = photoFiles.FileJoin
left join NewFiles badgeFiles on SCAOfficerPosition.BadgeURL = badgeFiles.FileJoin
left join NewFiles armsFiles on SCAPeople.ArmsURL = armsFiles.FileJoin
left join SCACrowns on SCAPeopleOfficer.LinkedCrownId = SCACrowns.CrownId
LEFT JOIN SCAPeople Consort ON SCACrowns.ConsortId = Consort.PeopleId
LEFT JOIN SCAPeople Sovereign ON SCACrowns.SovereignId = Sovereign.PeopleId
LEFT JOIN GroupTree on SCAPeople.BranchResidenceId = GroupTree.GroupId
JOIN iter_intlist_to_tbl(@OfficerPositionIds) i ON SCAOfficerPosition.OfficerPositionId = i.number
ORDER BY SCAOfficerPosition.ListOrder,  SCAPeopleOfficer.StartDate
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleOfficerList]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleOfficerList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleOfficerList]
AS

SELECT
	[PeopleOfficerId],
	[PeopleId],
	[OfficerPositionId],
	[StartDate],
	[EndDate],
	[CurrentlyHeld],
	[Acting],
	[Verified],
	PositionSubTitle,
	PositionNotes,
	EmailToUse,
	EmailOverride,
    VerifiedNotes
FROM SCAPeopleOfficer
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleOfficerGetByPeople]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleOfficerGetByPeople]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleOfficerGetByPeople]
	@PeopleId int
AS

SELECT
	[PeopleOfficerId],
	[PeopleId],
	[OfficerPositionId],
	[StartDate],
	[EndDate],
	[CurrentlyHeld],
	[Acting],
	[Verified],
PositionSubTitle,
PositionNotes
FROM SCAPeopleOfficer
WHERE
	[PeopleId]=@PeopleId
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleOfficerGetByOfficerPosition]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleOfficerGetByOfficerPosition]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleOfficerGetByOfficerPosition]
	@OfficerPositionId int
AS

WITH NewFiles(FileName, Width, Height, FileId,Folder, FileJoin) AS
(
Select FileName, Width, Height, FileId, Folder, ''fileid=''+ convert(varchar,FileID)
FROM Files
)

SELECT
	SCAPeopleOfficer.PeopleOfficerId as ID,
	SCAPeopleOfficer.PeopleId,
	SCAOfficerPosition.Title,
	SCAOfficerPosition.OfficerPositionId,
    case when BadgeFiles.FileName is null then SCAOfficerPosition.BadgeURL else BadgeFiles.Folder + BadgeFiles.FileName end as BadgeURL,
	case when BadgeFiles.Width is null then 0 else BadgeFiles.Width end as BadgeURLWidth,
	case when BadgeFiles.Height is null then 0 else BadgeFiles.Height end as BadgeURLHeight,
	SCAPeople.SCAName,
	MundaneName,
	Address1,
	Address2,
	City,
	State,
	Zip,
	Phone1,
	Phone2,
	EmailAddress,
	case when photoFiles.FileName is null then SCAPeople.PhotoURL else photoFiles.Folder + photoFiles.FileName end as PhotoUrl,
	case when photoFiles.Width is null then 0 else photoFiles.Width end as PhotoURLWidth,
	case when photoFiles.Height is null then 0 else photoFiles.Height end as PhotoURLHeight,
showpicpermission,
    case when armsFiles.FileName is null then SCAPeople.ArmsURL else armsFiles.Folder + armsFiles.FileName end as ArmsURL,
	case when armsFiles.Width is null then 0 else armsFiles.Width end as ArmsURLWidth,
	case when armsFiles.Height is null then 0 else armsFiles.Height end as ArmsURLHeight,
	OfficerNotes,
	[TitlePrefix],
	[HonorsSuffix],
	SCAGroups.Name AS GroupName,
	SCAGroups.GroupId,
	SCAPeopleOfficer.StartDate,
	SCAPeopleOfficer.EndDate,
	SCAPeopleOfficer.CurrentlyHeld,
	SCAPeopleOfficer.Acting,
	SCAPeopleOfficer.Verified,
	SCAPeopleOfficer.PositionSubTitle,
	SCAPeopleOfficer.PositionNotes,
	SCAOfficerPosition.ListOrder
FROM SCAPeopleOfficer 
JOIN SCAOfficerPosition ON SCAPeopleOfficer.OfficerPositionId = SCAOfficerPosition.OfficerPositionId 
JOIN SCAGroups ON SCAOfficerPosition.GroupId = SCAGroups.GroupId
JOIN SCAPeople on SCAPeopleOfficer.PeopleId = SCAPeople.PeopleId
left join NewFiles photoFiles on SCAPeople.PhotoURL = photoFiles.FileJoin
left join NewFiles badgeFiles on SCAOfficerPosition.BadgeURL = badgeFiles.FileJoin
left join NewFiles armsFiles on SCAPeople.ArmsURL = armsFiles.FileJoin
WHERE (SCAOfficerPosition.OfficerPositionId = @OfficerPositionId) 

Order By SCAPeopleOfficer.StartDate DESC

' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleOfficerGet]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleOfficerGet]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleOfficerGet]
	@PeopleOfficerId int
	
AS

SELECT
	[PeopleOfficerId],
	[PeopleId],
	[OfficerPositionId],
	[StartDate],
	[EndDate],
	[CurrentlyHeld],
	[Acting],
	[Verified]
FROM SCAPeopleOfficer
WHERE
	[PeopleOfficerId] = @PeopleOfficerId
	
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleOfficerDelete]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleOfficerDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleOfficerDelete]
	@PeopleOfficerId int
AS

DELETE FROM SCAPeopleOfficer
WHERE
	[PeopleOfficerId] = @PeopleOfficerId
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleOfficerAdd]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleOfficerAdd]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleOfficerAdd]
	@PeopleId int,
	@OfficerPositionId int,
	@StartDate datetime,
	@EndDate datetime,
	@CurrentlyHeld bit,
	@Acting bit,
	@Verified bit,
	@PositionSubTitle varchar(250),
	@PositionNotes varchar(max),
	@EmailToUse varchar(50),
	@EmailOverride nvarchar(100),
	@VerifiedNotes varchar(max),
	@LinkedCrownId int
AS

INSERT INTO SCAPeopleOfficer (
	[PeopleId],
	[OfficerPositionId],
	[StartDate],
	[EndDate],
	[CurrentlyHeld],
	[Acting],
	[Verified],
	PositionSubTitle,
	PositionNotes,
	EmailToUse,
	EmailOverride,
    VerifiedNotes, 
	LinkedCrownId
) VALUES (
	@PeopleId,
	@OfficerPositionId,
	@StartDate,
	@EndDate,
	@CurrentlyHeld,
	@Acting,
	@Verified,
	@PositionSubTitle,
	@PositionNotes,
	@EmailToUse,
	@EmailOverride,
	@VerifiedNotes,
	@LinkedCrownId
)

select SCOPE_IDENTITY()
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleOfficerUpdate]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleOfficerUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleOfficerUpdate]
	@PeopleOfficerId int, 
	@PeopleId int, 
	@OfficerPositionId int, 
	@StartDate datetime, 
	@EndDate datetime, 
	@CurrentlyHeld bit ,
	@Acting bit,
	@Verified bit,
	@PositionSubTitle varchar(250),
	@PositionNotes varchar(max),
	@EmailToUse varchar(50),
	@EmailOverride nvarchar(100),
	@VerifiedNotes varchar(max),
	@LinkedCrownId int
AS

UPDATE SCAPeopleOfficer SET
	[PeopleId] = @PeopleId,
	[OfficerPositionId] = @OfficerPositionId,
	[StartDate] = @StartDate,
	[EndDate] = @EndDate,
	[CurrentlyHeld] = @CurrentlyHeld,
	[Acting] = @Acting,
	[Verified] = @Verified,
	PositionSubTitle = @PositionSubTitle,
	PositionNotes  = @PositionNotes,
	EmailToUse = @EmailToUse,
	EmailOverride = @EmailOverride,
	VerifiedNotes = @VerifiedNotes,
	LinkedCrownId = @LinkedCrownId
WHERE
	[PeopleOfficerId] = @PeopleOfficerId
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleOfficerListRegnum]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleOfficerListRegnum]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleOfficerListRegnum]
 @GroupId int
AS

SELECT
	SCAPeopleOfficer.PeopleOfficerId as ID,
	SCAPeopleOfficer.PeopleId,
	SCAOfficerPosition.Title,
	SCAOfficerPosition.OfficerPositionId,
	SCAPeople.SCAName,
	MundaneName,
	Address1,
	Address2,
	City,
	State,
	Zip,
	Phone1,
	Phone2,
	EmailAddress,
	case when photoFiles.FileName is null then SCAPeople.PhotoURL else photoFiles.Folder + photoFiles.FileName end as PhotoURL,
	case when photoFiles.Width is null then 0 else photoFiles.Width end as PhotoURLWidth,
	case when photoFiles.Height is null then 0 else photoFiles.Height end as PhotoURLHeight,
	SCAGroups.Name AS GroupName,
	SCAGroups.GroupId,
	SCAPeopleOfficer.StartDate,
	SCAPeopleOfficer.EndDate,
	SCAPeopleOfficer.CurrentlyHeld,
	SCAPeopleOfficer.Acting,
	SCAPeopleOfficer.Verified,
	SCAPeopleOfficer.PositionSubTitle,
	SCAPeopleOfficer.PositionNotes,
	SCAOfficerPosition.ListOrder
FROM SCAPeopleOfficer 
JOIN SCAOfficerPosition ON SCAPeopleOfficer.OfficerPositionId = SCAOfficerPosition.OfficerPositionId 
JOIN SCAGroups ON SCAOfficerPosition.GroupId = SCAGroups.GroupId
JOIN SCAPeople on SCAPeopleOfficer.PeopleId = SCAPeople.PeopleId
left join Files photoFiles on SCAPeople.PhotoURL = ''fileid='' + convert(varchar,photoFiles.FileID)
WHERE (SCAOfficerPosition.GroupId = @GroupId) and SCAPeopleOfficer.CurrentlyHeld =1
UNION ALL 
SELECT
	SCACrowns.CrownId as ID,
	SCACrowns.SovereignId AS PeopleId,
	CASE WHEN heir =0  THEN '''' ELSE ''Heir to the '' END + 
	CASE gender WHEN ''M'' THEN SovereignMaleTitle WHEN ''F'' THEN SovereignFemaleTitle ELSE ''Sovereign'' END  
	 AS Title,
	''-1'' as OfficerPositionId,
	SCAPeople.SCAName,
	MundaneName,
	Address1,
	Address2,
	City,
	State,
	Zip,
	Phone1,
	Phone2,
	EmailAddress,
	case when photoFiles.FileName is null then SCAPeople.PhotoURL else photoFiles.Folder + photoFiles.FileName end as PhotoURL,
	case when photoFiles.Width is null then 0 else photoFiles.Width end as PhotoURLWidth,
	case when photoFiles.Height is null then 0 else photoFiles.Height end as PhotoURLHeight,
	SCAGroups.Name AS GroupName,
	SCAGroups.GroupId,
	SCACrowns.StartDate,
	SCACrowns.EndDate,
	CASE WHEN SCACrowns.Reign = (SELECT
	MAX(Reign)
FROM SCACrowns wC
WHERE wC.GroupId = SCAGroups.GroupId) THEN 1 ELSE 0 END AS CurrentlyHeld,
	0 as Acting,
	1 as Verified,
'''' as PositionSubTitle,
'''' as PositionNotes,
	-1004 as ListOrder
FROM SCACrowns 
JOIN SCAGroups ON SCACrowns.GroupId = SCAGroups.GroupId 
JOIN SCAPeople ON SCACrowns.SovereignId = SCAPeople.PeopleId
left join Files photoFiles on SCAPeople.PhotoURL = ''fileid='' + convert(varchar,photoFiles.FileID)
WHERE (SCACrowns.GroupId = @GroupId) and SCACrowns.Reign = (SELECT
	MAX(Reign) 
FROM SCACrowns wC
WHERE wC.GroupId = SCAGroups.GroupId and Heir=0) and Heir=0
UNION ALL 
SELECT
	SCACrowns.CrownId as ID,
	SCACrowns.ConsortId AS PeopleId,
	CASE WHEN heir =0  THEN '''' ELSE ''Heir to the '' END + 
	CASE gender WHEN ''M'' THEN ConsortMaleTitle WHEN ''F'' THEN ConsortFemaleTitle ELSE ''Consort'' END
	 AS Title,
	''-1'' as OfficerPositionId,
	SCAPeople.SCAName,
	MundaneName,
	Address1,
	Address2,
	City,
	State,
	Zip,
	Phone1,
	Phone2,
	EmailAddress,
	case when photoFiles.FileName is null then SCAPeople.PhotoURL else photoFiles.Folder + photoFiles.FileName end as PhotoURL,
	case when photoFiles.Width is null then 0 else photoFiles.Width end as PhotoURLWidth,
	case when photoFiles.Height is null then 0 else photoFiles.Height end as PhotoURLHeight,
	SCAGroups.Name AS GroupName,
	SCAGroups.GroupId,
	SCACrowns.StartDate,
	SCACrowns.EndDate,
	CASE WHEN SCACrowns.Reign = (SELECT
	MAX(Reign)
FROM SCACrowns wC
WHERE wC.GroupId = SCAGroups.GroupId) THEN 1 ELSE 0 END AS CurrentlyHeld,
	0 as Acting,
	1 as Verified,
'''' as PositionSubTitle,
'''' as PositionNotes,
	-1003 as ListOrder
FROM SCACrowns 
JOIN SCAGroups ON SCACrowns.GroupId = SCAGroups.GroupId 
JOIN SCAPeople ON SCACrowns.Consortid = SCAPeople.PeopleId
left join Files photoFiles on SCAPeople.PhotoURL = ''fileid='' + convert(varchar,photoFiles.FileID)
WHERE (SCACrowns.GroupId = @GroupId) and SCACrowns.Reign = (SELECT
	MAX(Reign)
FROM SCACrowns wC
WHERE wC.GroupId = SCAGroups.GroupId and Heir=0)  and Heir=0

UNION ALL
SELECT
	SCACrowns.CrownId as ID,
	SCACrowns.SovereignId AS PeopleId,
	CASE WHEN heir =0  THEN '''' ELSE ''Heir to the '' END + 
	CASE gender WHEN ''M'' THEN SovereignMaleTitle WHEN ''F'' THEN SovereignFemaleTitle ELSE ''Sovereign'' END  
	 AS Title,
	''-1'' as OfficerPositionId,
	SCAPeople.SCAName,
	MundaneName,
	Address1,
	Address2,
	City,
	State,
	Zip,
	Phone1,
	Phone2,
	EmailAddress,
	case when photoFiles.FileName is null then SCAPeople.PhotoURL else photoFiles.Folder + photoFiles.FileName end as PhotoURL,
	case when photoFiles.Width is null then 0 else photoFiles.Width end as PhotoURLWidth,
	case when photoFiles.Height is null then 0 else photoFiles.Height end as PhotoURLHeight,
	SCAGroups.Name AS GroupName,
	SCAGroups.GroupId,
	SCACrowns.StartDate,
	SCACrowns.EndDate,
	CASE WHEN SCACrowns.Reign = (SELECT
	MAX(Reign)
FROM SCACrowns wC
WHERE wC.GroupId = SCAGroups.GroupId) THEN 1 ELSE 0 END AS CurrentlyHeld,
	0 as Acting,
	1 as Verified,
'''' as PositionSubTitle,
'''' as PositionNotes,
	-1002 as ListOrder
FROM SCACrowns 
JOIN SCAGroups ON SCACrowns.GroupId = SCAGroups.GroupId 
JOIN SCAPeople ON SCACrowns.SovereignId = SCAPeople.PeopleId
left join Files photoFiles on SCAPeople.PhotoURL = ''fileid='' + convert(varchar,photoFiles.FileID)
WHERE (SCACrowns.GroupId = @GroupId) and SCACrowns.Reign = (SELECT
	MAX(Reign) 
FROM SCACrowns wC
WHERE wC.GroupId = SCAGroups.GroupId and Heir=1) and Heir=1
UNION ALL 
SELECT
	SCACrowns.CrownId as ID,
	SCACrowns.ConsortId AS PeopleId,
	CASE WHEN heir =0  THEN '''' ELSE ''Heir to the '' END + 
	CASE gender WHEN ''M'' THEN ConsortMaleTitle WHEN ''F'' THEN ConsortFemaleTitle ELSE ''Consort'' END
	 AS Title,
	''-1'' as OfficerPositionId,
	SCAPeople.SCAName,
	MundaneName,
	Address1,
	Address2,
	City,
	State,
	Zip,
	Phone1,
	Phone2,
	EmailAddress,
	case when photoFiles.FileName is null then SCAPeople.PhotoURL else photoFiles.Folder + photoFiles.FileName end as PhotoURL,
	case when photoFiles.Width is null then 0 else photoFiles.Width end as PhotoURLWidth,
	case when photoFiles.Height is null then 0 else photoFiles.Height end as PhotoURLHeight,
	SCAGroups.Name AS GroupName,
	SCAGroups.GroupId,
	SCACrowns.StartDate,
	SCACrowns.EndDate,
	CASE WHEN SCACrowns.Reign = (SELECT
	MAX(Reign)
FROM SCACrowns wC
WHERE wC.GroupId = SCAGroups.GroupId) THEN 1 ELSE 0 END AS CurrentlyHeld,
	0 as Acting,
	1 as Verified,
'''' as PositionSubTitle,
'''' as PositionNotes,
	-1001 as ListOrder
FROM SCACrowns 
JOIN SCAGroups ON SCACrowns.GroupId = SCAGroups.GroupId 
JOIN SCAPeople ON SCACrowns.Consortid = SCAPeople.PeopleId
left join Files photoFiles on SCAPeople.PhotoURL = ''fileid='' + convert(varchar,photoFiles.FileID)
WHERE (SCACrowns.GroupId = @GroupId) and SCACrowns.Reign = (SELECT
	MAX(Reign)
FROM SCACrowns wC
WHERE wC.GroupId = SCAGroups.GroupId and Heir=1)  and Heir=1
Order By ListOrder ASC, SCAName ASC' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleListFilter]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleListFilter]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleListFilter]
@Filter varchar(200),
@SearchField varchar(1),
@OrderBy varchar (1),
@OnlyPhotos bit,
@OnlyDevices bit,
@IncludeAliases bit,
@OnlyDeceased bit,
@OnlyLiving bit,
@BaseKingdom int,
@OnlyResidents bit,
@OnlyNonResidents bit
AS
--
--DECLARE @Filter varchar(200),
--@SearchField varchar(1),
--@OrderBy varchar (1),
--@OnlyPhotos bit,
--@OnlyDevices bit,
--@IncludeAliases bit,
--@OnlyDeceased bit,
--@OnlyLiving bit,
--@BaseKingdom int,
--@OnlyResidents bit,
--@OnlyNonResidents bit
--
--
--SET @Filter=''%''
--SET @SearchField=''n''
--SET @OrderBy=''a''
--SET @OnlyPhotos=0
--SET @OnlyDevices=0
--SET @IncludeAliases=0
--SET @OnlyDeceased=0
--SET @OnlyLiving=0
--SET @BaseKingdom=26
--SET @OnlyResidents=0
--SET @OnlyNonResidents=1;

WITH ParentKingdom(GroupId,  ParentKingdom)
AS 
(
SELECT
	SCAGroups.GroupId,
	SCAGroups.GroupId
FROM SCAGroups
where ParentGroupId is null
UNION ALL 
SELECT 
SCAGroups.GroupId,
   ParentKingdom
FROM SCAGroups
JOIN ParentKingdom  ON SCAGroups.ParentGroupId = ParentKingdom.GroupId
)
--Select * from ParentKingdom

SELECT  PeopleId,
	SCAName,
	PhotoFileLink,
	ArmsFileLink,
	ArmsBlazon,
	ShowPicPermission,
	ShowEmailPermission,
	OPNum,
	HighestAwardName,
	HighestAwardDate,
	Cast(HighestAwardId as int) As HighestAwardId,
	CrownId,
	Deceased,
	[DeceasedWhen],
	[BranchResidenceId],
	BranchResidence,
	ParentKingdom,
	Gender,
	case when photoFiles.FileName is null then null else photoFiles.Folder + photoFiles.FileName end as PhotoURL,
	case when photoFiles.Width is null then 0 else photoFiles.Width end as PhotoURLWidth,
	case when photoFiles.Height is null then 0 else photoFiles.Height end as PhotoURLHeight,
	case when armsFiles.FileName is null then null else armsFiles.Folder + armsFiles.FileName end as ArmsURL,
	case when armsFiles.Width is null then 0 else armsFiles.Width end as ArmsURLWidth,
	case when armsFiles.Height is null then 0 else armsFiles.Height end as ArmsURLHeight

 FROM (
	SELECT
		SCAPeople.PeopleId as PeopleId,
		SCAPeople.SCAName as SCAName,
		convert(int,Replace(SCAPeople.PhotoURL,''fileid='','''')) as PhotoFileLink,
		convert(int,Replace(SCAPeople.ArmsURL, ''fileid='',''''))as ArmsFileLink,
		SCAPeople.ArmsBlazon as ArmsBlazon,
		SCAPeople.ShowPicPermission,
		SCAPeople.ShowEmailPermission,
		CASE WHEN SCAPeople.OPNum Is NULL THEN 999999 ELSE SCAPeople.OpNum END as OPNum,
		HighestAwardName,
		HighestAwardDate,
		HighestAwardId,
		CrownId,
		Deceased,
		[DeceasedWhen],
		[BranchResidenceId],
		branchresidence.Name as BranchResidence,
		ParentKingdom,
		Gender,
		case when gender = ''P'' then 1 else 0 end as animalsort
	FROM SCAPeople
	left join scagroups branchresidence on SCAPeople.BranchResidenceId = branchresidence.GroupId
	left join ParentKingdom on ParentKingdom.GroupId = BranchResidenceId
	WHERE ((@SearchField = ''n'' and SCAPeople.SCAName Like @Filter) OR (@SearchField = ''b'' and SCAPeople.ArmsBlazon Like @Filter))
	AND (@OnlyPhotos = 0  OR (SCAPeople.PhotoURL Is Not Null and SCAPeople.ShowPicPermission = 1))
	AND (@OnlyDevices = 0 OR SCAPeople.ArmsURL Is Not Null)
	AND (@OnlyDeceased = 0 OR SCAPeople.Deceased = 1)
	AND (@OnlyLiving = 0 OR SCAPeople.Deceased = 0)
	AND (@OnlyResidents = 0 OR ParentKingdom = @BaseKingdom)
	AND (@OnlyNonResidents = 0 OR ParentKingdom <> @BaseKingdom)
	UNION
	SELECT
		SCAPeople.PeopleId as PeopleId,
		SCAAlias.SCAName as SCAName,
		convert(int,Replace(SCAPeople.PhotoURL,''fileid='','''')) as PhotoFileLink,
		convert(int,Replace(SCAPeople.ArmsURL, ''fileid='',''''))as ArmsFileLink,
		SCAPeople.ArmsBlazon as ArmsBlazon,
		SCAPeople.ShowPicPermission,
		SCAPeople.ShowEmailPermission,
		CASE WHEN SCAPeople.OPNum Is NULL THEN 999999 ELSE SCAPeople.OpNum END as OPNum,
		HighestAwardName,
		HighestAwardDate,
		HighestAwardId,
		CrownId,
		Deceased,
		[DeceasedWhen],
		[BranchResidenceId],
		branchresidence.Name as BranchResidence,
		ParentKingdom,
		Gender,
		case when gender = ''P'' then 1 else 0 end as animalsort
	FROM SCAPeople
	left join scagroups branchresidence on SCAPeople.BranchResidenceId = branchresidence.GroupId
	left join ParentKingdom on ParentKingdom.GroupId = BranchResidenceId
	JOIN SCAAlias on SCAAlias.PeopleId = SCAPeople.PeopleId
	WHERE @IncludeAliases=1 AND 
	((@SearchField = ''n'' and SCAAlias.SCAName Like @Filter) OR (@SearchField = ''b'' and SCAPeople.ArmsBlazon Like @Filter))
	AND (@OnlyPhotos = 0  OR (SCAPeople.PhotoURL Is Not Null and SCAPeople.ShowPicPermission = 1))
	AND (@OnlyDevices = 0 OR SCAPeople.ArmsURL Is Not Null)
	AND (@OnlyDeceased = 0 OR SCAPeople.Deceased = 1)
	AND (@OnlyLiving = 0 OR SCAPeople.Deceased = 0)
	AND (@OnlyResidents = 0 OR ParentKingdom = @BaseKingdom)
	AND (@OnlyNonResidents = 0 OR ParentKingdom <> @BaseKingdom)
	) SearchList
left join Files photoFiles on SearchList.PhotoFileLink = photoFiles.FileID
left join Files armsFiles on SearchList.ArmsFileLink = armsFiles.FileID
Order By 
animalsort,
CASE WHEN @OrderBy = ''a'' and @SearchField = ''n''  THEN SCAName END,
CASE WHEN @OrderBy = ''a'' and @SearchField = ''b''  THEN ArmsBlazon END,
CASE WHEN @OrderBy = ''n'' THEN SCAName END,
CASE WHEN @OrderBy = ''b'' Then ArmsBlazon END,
CASE WHEN @OrderBy = ''p'' Then OpNum END,
SCAName	
--
--
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleListAlphaCount]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleListAlphaCount]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleListAlphaCount]
AS

SELECT     LEFT(SCANAME, 1) AS Alpha, COUNT(*) AS NameCount
FROM         (SELECT     SCAName
                       FROM          SCAPeople
                       UNION
                       SELECT     SCAName
                       FROM         SCAAlias) AllNames
GROUP BY LEFT(SCANAME, 1)
ORDER BY Alpha ASC' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleGetRegisteredName]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleGetRegisteredName]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleGetRegisteredName]
	@PeopleId int
AS

SELECT     TOP 1 CASE SCAAlias.Registered WHEN 1 THEN SCAAlias.SCAName ELSE SCAPeople.SCAName END AS SCAName
FROM         SCAPeople LEFT OUTER JOIN
                      SCAAlias ON SCAAlias.PeopleId = SCAPeople.PeopleId
WHERE     (SCAPeople.PeopleId = @PeopleId)
ORDER BY SCAAlias.Registered DESC
	
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAGroupsListForAwards]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroupsListForAwards]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAGroupsListForAwards]
AS

WITH GroupTree(GroupId, Name, GroupName, Level, Sort)
AS 
(
SELECT
	SCAGroups.GroupId,
	SCAGroups.Name,
	SCAGroups.Name as GroupName,
	1,
    CONVERT(varchar(max), CONVERT(char(50), SCAGroups.Name) + ''|'')
FROM SCAGroups
where ParentGroupId is null
UNION ALL 
SELECT 
SCAGroups.GroupId,
	SCAGroups.Name,
	SCAGroups.Name as GroupName,
    Level + 1,
CONVERT(varchar(max), Sort + CONVERT(char(50), SCAGroups.Name) + ''|'')
FROM SCAGroups
JOIN GroupTree  ON SCAGroups.ParentGroupId = GroupTree.GroupId
)
SELECT GroupId,
GroupName,
Level,
RTRIM(SUBSTRING(sort, 1, 50)) AS lvl1,
RTRIM(SUBSTRING(sort, 52, 50)) AS lvl2,
RTRIM(SUBSTRING(sort, 103, 50)) AS lvl3,
RTRIM(SUBSTRING(sort, 154, 50)) AS lvl4,

	AwardCount = (SELECT COUNT(*) FROM
(SELECT DISTINCT
	COALESCE(SCAAwardGroups.AwardGroupId ,SCAAwards.AwardId )AS AwardId,
	COALESCE(SCAAwardGroups.AwardGroupName, SCAAwards.Name ) AS Name,
	COALESCE(SCAAwardGroups.Precedence, SCAAwards.Precedence, 1000 )AS Precedence,
	COALESCE(SCAAwardGroups.SortOrder, SCAAwards.SortOrder ) AS SortOrder
FROM SCAAwards 
LEFT JOIN SCAAwardGroups ON SCAAwards.AwardGroupId = SCAAwardGroups.AwardGroupId
WHERE SCAAwards.GroupId = GroupTree.GroupId) awardCount) ,

	GroupTree.Name + '' ('' + Convert(varchar(5), (SELECT COUNT(*) FROM
(SELECT DISTINCT
	COALESCE(SCAAwardGroups.AwardGroupId ,SCAAwards.AwardId )AS AwardId,
	COALESCE(SCAAwardGroups.AwardGroupName, SCAAwards.Name ) AS Name,
	COALESCE(SCAAwardGroups.Precedence, SCAAwards.Precedence, 1000 )AS Precedence,
	COALESCE(SCAAwardGroups.SortOrder, SCAAwards.SortOrder ) AS SortOrder
FROM SCAAwards 
LEFT JOIN SCAAwardGroups ON SCAAwards.AwardGroupId = SCAAwardGroups.AwardGroupId
WHERE SCAAwards.GroupId = GroupTree.GroupId) awardCount)) + '' Awards)'' as GroupNameAwardCount

From GroupTree

where (Select Count(*) from SCAAwards where SCAAwards.GroupId = GroupTree.GroupId) >0
Order By Sort


' 
END
GO
/****** Object:  Table {databaseOwner}.{objectQualifier}[SCAPeopleAward]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleAward]') AND type in (N'U'))
BEGIN
CREATE TABLE {databaseOwner}.{objectQualifier}[SCAPeopleAward](
	[PeopleAwardId] [int] IDENTITY(1,1) NOT NULL,
	[AwardId] [int] NOT NULL,
	[PeopleId] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
	[CrownId] [int] NULL,
	[Notes] [nvarchar](500) NULL,
	[AliasId] [int] NULL,
	[Retired] [bit] NOT NULL,
 CONSTRAINT [PK_SCAPeopleAward] PRIMARY KEY NONCLUSTERED 
(
	[PeopleAwardId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UC_SCAPeopleAward_PeopleId_Date] UNIQUE NONCLUSTERED 
(
	[PeopleId] ASC,
	[Date] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleAward]') AND name = N'CX_SCAPeopleAward')
CREATE CLUSTERED INDEX [CX_SCAPeopleAward] ON {databaseOwner}.{objectQualifier}[SCAPeopleAward] 
(
	[PeopleId] ASC,
	[AwardId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleAward]') AND name = N'IDX_SCAPeopleAward_PeopleId_Retired_AwardId_Date')
CREATE NONCLUSTERED INDEX [IDX_SCAPeopleAward_PeopleId_Retired_AwardId_Date] ON {databaseOwner}.{objectQualifier}[SCAPeopleAward] 
(
	[PeopleId] ASC,
	[Retired] ASC,
	[AwardId] ASC,
	[Date] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleCombinedOfficesGet]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleCombinedOfficesGet]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleCombinedOfficesGet]
	@PeopleId int
AS

SELECT
	SCAPeopleOfficer.PeopleOfficerId as ID,
	SCAPeopleOfficer.PeopleId,
	SCAOfficerPosition.Title,
	SCAOfficerPosition.OfficerPositionId,
	SCAOfficerPosition.OfficeEmail,
	SCAPeopleOfficer.EmailToUse,
	SCAPeopleOfficer.EmailOverride,
	SCAOfficerPosition.LinkedToCrown,
	SCAGroups.Name AS GroupName,
	SCAGroups.GroupId,
	SCAPeopleOfficer.StartDate,
	SCAPeopleOfficer.EndDate,
	SCAPeopleOfficer.CurrentlyHeld,
	SCAPeopleOfficer.Acting,
	SCAPeopleOfficer.Verified,
	SCAPeopleOfficer.PositionSubTitle,
	SCAPeopleOfficer.PositionNotes,
	SCAPeopleOfficer.VerifiedNotes,
	Cast(0 as bit) as RulingOffice,
	LinkedCrownId,
			CASE 
				WHEN LEFT(Sovereign.SCAName, CASE WHEN PATINDEX(''% %'',Sovereign.SCAName)>0 THEN PATINDEX(''% %'',Sovereign.SCAName) -1 ELSE 0 END) = '''' THEN Sovereign.SCAName 
				ELSE LEFT(Sovereign.SCAName, CASE WHEN PATINDEX(''% %'',Sovereign.SCAName)>0 THEN PATINDEX(''% %'',Sovereign.SCAName) -1 ELSE 0 END) END + 
			CASE 
				WHEN Consort.SCAName IS NULL THEN '''' 
				ELSE '' and '' END + 
			CASE 
				WHEN Consort.SCAName IS NULL THEN ''''  
				WHEN LEFT(Consort.SCAName,CASE WHEN PATINDEX(''% %'',Consort.SCAName)>0 THEN PATINDEX(''% %'',Consort.SCAName) -1 ELSE 0 END) = '''' THEN Consort.SCAName 
				ELSE LEFT(Consort.SCAName,CASE WHEN PATINDEX(''% %'',Consort.SCAName)>0 THEN PATINDEX(''% %'',Consort.SCAName) -1 ELSE 0 END) END 
	AS LinkedCrownDisplay
FROM SCAPeopleOfficer 
JOIN SCAOfficerPosition ON SCAPeopleOfficer.OfficerPositionId = SCAOfficerPosition.OfficerPositionId 
JOIN SCAGroups ON SCAOfficerPosition.GroupId = SCAGroups.GroupId
left join SCACrowns on SCAPeopleOfficer.LinkedCrownId = SCACrowns.CrownId
LEFT JOIN SCAPeople Consort ON SCACrowns.ConsortId = Consort.PeopleId
LEFT JOIN SCAPeople Sovereign ON SCACrowns.SovereignId = Sovereign.PeopleId
WHERE (SCAPeopleOfficer.PeopleId = @PeopleId)
UNION ALL 
SELECT
	SCACrowns.CrownId as ID,
	SCACrowns.SovereignId AS PeopleId,
	CASE WHEN heir =0  THEN '''' ELSE ''Heir to the '' END + 
	CASE WHEN regent = 0 THEN
	CASE gender WHEN ''M'' THEN SovereignMaleTitle WHEN ''F'' THEN SovereignFemaleTitle ELSE ''Sovereign'' END  
	ELSE
	CASE gender WHEN ''M'' THEN RegentMaleTitle WHEN ''F'' THEN RegentFemaleTitle ELSE ''Regent'' END  
	 END
	 AS Title ,
	''-1'' as OfficerPositionId,
	SCACrowns.Email,
	'''' as EmailToUse,
	'''' as EmailOverride,
	Cast(0 as bit) as LinkedToCrown,
	SCAGroups.Name AS GroupName,
	SCAGroups.GroupId,
	SCACrowns.StartDate,
	SCACrowns.EndDate,
			CASE WHEN (SCACrowns.Reign = (SELECT
			MAX(Reign)
			FROM SCACrowns wC
			WHERE wC.GroupId = SCAGroups.GroupId  AND wC.Heir=0) OR heir =1)
			AND SCAGroups.BranchStatusId = 1 AND 
			(SCACrowns.EndDate IS NULL OR SCACrowns.EndDate> GetDate())
			THEN 1 ELSE 0 END
	AS CurrentlyHeld,
	0 as Acting,
	1 as Verified,
	'''' as PositionSubTitle,
	'''' as PositionNotes,
	'''' as VerifiedNotes,
	Cast(1 as bit) as RulingOffice,
	Null as LinkedCrownId, 
	Null As LinkedCrownDisplay
FROM SCACrowns 
JOIN SCAGroups ON SCACrowns.GroupId = SCAGroups.GroupId 
JOIN SCAPeople ON SCACrowns.SovereignId = SCAPeople.PeopleId
WHERE (SCACrowns.SovereignId = @PeopleId)
UNION ALL 
SELECT
	SCACrowns.CrownId as ID,
	SCACrowns.ConsortId AS PeopleId,
	CASE WHEN heir =0  THEN '''' ELSE ''Heir to the '' END + 
	CASE WHEN regent = 0 THEN
	CASE gender WHEN ''M'' THEN ConsortMaleTitle WHEN ''F'' THEN ConsortFemaleTitle ELSE ''Consort'' END
	ELSE
	CASE gender WHEN ''M'' THEN RegentMaleTitle WHEN ''F'' THEN RegentFemaleTitle ELSE ''Regent'' END  
	 END
	 AS Title,
	''-1'' as OfficerPositionId,
	SCACrowns.Email,
	'''' as EmailToUse,
	'''' as EmailOverride,
	Cast(0 as bit) as LinkedToCrown,
	SCAGroups.Name AS GroupName,
	SCAGroups.GroupId,
	SCACrowns.StartDate,
	SCACrowns.EndDate,
			CASE WHEN (SCACrowns.Reign = (SELECT
			MAX(Reign)
			FROM SCACrowns wC
			WHERE wC.GroupId = SCAGroups.GroupId AND wC.Heir=0) OR heir =1)
			AND SCAGroups.BranchStatusId = 1 AND 
			(SCACrowns.EndDate IS NULL OR SCACrowns.EndDate> GetDate())
			THEN 1 ELSE 0 END 
	AS CurrentlyHeld,
	0 as Acting,
	1 as Verified,
	'''' as PositionSubTitle,
	'''' as PositionNotes,
	'''' as VerifiedNotes,
	Cast(1 as bit) as RulingOffice,
	Null as LinkedCrownId, 
	Null As LinkedCrownDisplay
FROM SCACrowns 
JOIN SCAGroups ON SCACrowns.GroupId = SCAGroups.GroupId 
JOIN SCAPeople ON SCACrowns.ConsortId = SCAPeople.PeopleId
WHERE (SCACrowns.ConsortId = @PeopleId)
Order By CurrentlyHeld DESC, StartDate DESC


' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCACrownLettersUpdate]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCACrownLettersUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCACrownLettersUpdate]
	@CrownLetterId int, 
	@CrownId int, 
	@Title varchar(200), 
	@Letter ntext 
AS

UPDATE SCACrownLetters SET
	[CrownId] = @CrownId,
	[Title] = @Title,
	[Letter] = @Letter
WHERE
	[CrownLetterId] = @CrownLetterId
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCACrownLettersList]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCACrownLettersList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCACrownLettersList]
AS

SELECT
	[CrownLetterId],
	[CrownId],
	[Title],
	[Letter]
FROM SCACrownLetters
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCACrownLettersGetByCrowns]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCACrownLettersGetByCrowns]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCACrownLettersGetByCrowns]
	@CrownId int
AS

SELECT
	[CrownLetterId],
	[CrownId],
	[Title],
	[Letter]
FROM SCACrownLetters
WHERE
	[CrownId]=@CrownId
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCACrownLettersGet]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCACrownLettersGet]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCACrownLettersGet]
	@CrownLetterId int
	
AS

SELECT
	[CrownLetterId],
	[CrownId],
	[Title],
	[Letter]
FROM SCACrownLetters
WHERE
	[CrownLetterId] = @CrownLetterId
	
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCACrownLettersDelete]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCACrownLettersDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCACrownLettersDelete]
	@CrownLetterId int
AS

DELETE FROM SCACrownLetters
WHERE
	[CrownLetterId] = @CrownLetterId
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCACrownLettersAdd]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCACrownLettersAdd]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCACrownLettersAdd]
	@CrownId int,
	@Title varchar(200),
	@Letter ntext
AS

INSERT INTO SCACrownLetters (
	[CrownId],
	[Title],
	[Letter]
) VALUES (
	@CrownId,
	@Title,
	@Letter
)

select SCOPE_IDENTITY()
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAAwardsGetByGroups]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAwardsGetByGroups]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAAwardsGetByGroups]
@filter nvarchar(500)
AS

DECLARE @SQL nvarchar(3500)
IF(@filter=''*'')
SELECT DISTINCT
	COALESCE(SCAAwardGroups.AwardGroupId ,SCAAwards.AwardId )AS AwardId,
	SCAAwards.GroupId,
	COALESCE(SCAAwardGroups.AwardGroupName, SCAAwards.Name ) AS Name,
	COALESCE(SCAAwardGroups.AwardGroupName, SCAAwards.Name ) AS AwardName,
	COALESCE(SCAAwardGroups.Precedence, SCAAwards.Precedence, 1000 )AS Precedence,
	COALESCE(SCAAwardGroups.SortOrder, SCAAwards.SortOrder ) AS SortOrder,
	SCAAwards.Closed,
	SCAGroups.Name AS GroupName,
	SCAGroups.Precedence as GroupPrecedence,
	CASE WHEN SCAAwards.AwardGroupId IS NULL then ''aid'' Else ''gaid'' END as AwardType
FROM SCAAwards 
JOIN SCAGroups ON SCAAwards.GroupId = SCAGroups.GroupId
LEFT JOIN SCAAwardGroups ON SCAAwards.AwardGroupId = SCAAwardGroups.AwardGroupId
ORDER By Precedence, SortOrder, SCAGroups.Precedence, Name
ELSE
BEGIN
SET @SQL = ''
SELECT DISTINCT
	COALESCE(SCAAwardGroups.AwardGroupId ,SCAAwards.AwardId )AS AwardId,
	SCAAwards.GroupId,
	COALESCE(SCAAwardGroups.AwardGroupName, SCAAwards.Name ) AS Name,
    COALESCE(SCAAwardGroups.AwardGroupName, SCAAwards.Name ) AS AwardName,
	COALESCE(SCAAwardGroups.Precedence, SCAAwards.Precedence, 1000 )AS Precedence,
	COALESCE(SCAAwardGroups.SortOrder, SCAAwards.SortOrder ) AS SortOrder,
	SCAAwards.Closed,
	SCAGroups.Name AS GroupName,
	SCAGroups.Precedence as GroupPrecedence,
	CASE WHEN SCAAwards.AwardGroupId IS NULL then ''''aid'''' Else ''''gaid'''' END as AwardType
FROM SCAAwards 
JOIN SCAGroups ON SCAAwards.GroupId = SCAGroups.GroupId
LEFT JOIN SCAAwardGroups ON SCAAwards.AwardGroupId = SCAAwardGroups.AwardGroupId
WHERE SCAGroups.GroupId in ('' + @filter + '')
ORDER By Precedence, SortOrder, SCAGroups.Precedence, Name''

exec sp_executesql @sql
PRINT @sql
END' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAAwardsGetByAwardGroups]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAwardsGetByAwardGroups]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAAwardsGetByAwardGroups]
	@AwardGroupId int
AS

SELECT
	SCAAwards.AwardId,
	SCAAwards.GroupId,
	SCAAwards.Name,
	SCAAwards.Charter,
	SCAAwards.Precedence,
	SCAAwards.SortOrder,
	case when BadgeFiles.FileName is null then SCAAwards.BadgeUrl else BadgeFiles.Folder + BadgeFiles.FileName end as BadgeUrl,
	case when BadgeFiles.Width is null then 0 else BadgeFiles.Width end as BadgeUrlWidth,
	case when BadgeFiles.Height is null then 0 else BadgeFiles.Height end as BadgeUrlHeight,
	SCAAwards.BadgeBlazon,
	SCAAwards.Closed,
	SCAAwards.AwardedById,
	SCAAwards.AwardGroupId,
	SCAGroups.Name AS GroupName,
	SCAGroups.Name + '' -'' + SCAAwards.Name AS GroupAward,
	SCAAwardGroups.AwardGroupName,
	SCAAwards.Honorary 
FROM SCAAwards 
JOIN SCAGroups ON SCAAwards.GroupId = SCAGroups.GroupId
LEFT JOIN SCAAwardGroups ON SCAAwards.AwardGroupId = SCAAwardGroups.AwardGroupId
Left join Files BadgeFiles on SCAAwards.BadgeUrl = ''fileid='' + convert(varchar,BadgeFiles.FileID)
WHERE
	SCAAwards.[AwardGroupId]=@AwardGroupId
	ORDER by SCAAwards.Precedence, SCAAwards.SortOrder, SCAAwards.Name

' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAAwardsGet]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAwardsGet]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAAwardsGet]
	@AwardId int
AS

SELECT
	SCAAwards.AwardId,
	SCAAwards.GroupId,
	SCAAwards.Name,
	SCAAwards.Charter,
	SCAAwards.Precedence,
	SCAAwards.SortOrder,
	case when BadgeFiles.FileName is null then SCAAwards.BadgeUrl else BadgeFiles.Folder + BadgeFiles.FileName end as BadgeUrl,
	case when BadgeFiles.Width is null then 0 else BadgeFiles.Width end as BadgeUrlWidth,
	case when BadgeFiles.Height is null then 0 else BadgeFiles.Height end as BadgeUrlHeight,
	SCAAwards.BadgeBlazon,
	SCAAwards.Closed,
	SCAAwards.AwardedById,
	SCAAwards.AwardGroupId,
	SCAGroups.Name AS GroupName,
	SCAGroups.Name + '' -'' + SCAAwards.Name AS GroupAward,
	SCAAwardGroups.AwardGroupName,
	SCAAwards.Honorary 
FROM SCAAwards 
JOIN SCAGroups ON SCAAwards.GroupId = SCAGroups.GroupId
LEFT JOIN SCAAwardGroups ON SCAAwards.AwardGroupId = SCAAwardGroups.AwardGroupId
left join Files BadgeFiles on SCAAwards.BadgeUrl = ''fileid='' + convert(varchar,BadgeFiles.FileID)
WHERE (SCAAwards.AwardId = @AwardId) 

	
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAAwardsDelete]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAwardsDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAAwardsDelete]
	@AwardId int
AS

DELETE FROM SCAAwards
WHERE
	[AwardId] = @AwardId
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAAwardsAdd]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAwardsAdd]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAAwardsAdd]
	@GroupId int,
	@Name nvarchar(200),
	@Charter ntext,
	@Precedence int,
	@SortOrder int,
	@BadgeUrl varchar(300),
	@BadgeBlazon nvarchar(4000),
	@Closed bit,
	@AwardedById int,
	@AwardGroupId int,
	@Honorary bit	
AS

INSERT INTO SCAAwards (
	[GroupId],
	[Name],
	[Charter],
	[Precedence],
	[SortOrder],
	[BadgeUrl],
	[BadgeBlazon],
	[Closed],
	[AwardedById],
	[AwardGroupId],
	[Honorary]
) VALUES (
	@GroupId,
	@Name,
	@Charter,
	@Precedence,
	@SortOrder,
	@BadgeUrl,
	@BadgeBlazon,
	@Closed,
	@AwardedById,
	@AwardGroupId,
	@Honorary
)

select SCOPE_IDENTITY()
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAAliasUpdate]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAliasUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAAliasUpdate]
	@AliasId int, 
	@PeopleId int, 
	@SCAName nvarchar(300), 
	@Registered bit, 
	@Preferred bit 
AS

UPDATE SCAAlias SET
	[PeopleId] = @PeopleId,
	[SCAName] = @SCAName,
	[Registered] = @Registered,
	[Preferred] = @Preferred
WHERE
	[AliasId] = @AliasId
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAAliasList]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAliasList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAAliasList]
AS

SELECT
	[AliasId],
	[PeopleId],
	[SCAName],
	[Registered],
	[Preferred]
FROM SCAAlias
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAAliasGetByPeople]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAliasGetByPeople]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAAliasGetByPeople]
	@PeopleId int
AS

SELECT
	[AliasId],
	[PeopleId],
	[SCAName],
	[Registered],
	[Preferred]
FROM SCAAlias
WHERE
	[PeopleId]=@PeopleId
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAAliasGet]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAliasGet]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAAliasGet]
	@AliasId int
	
AS

SELECT
	[AliasId],
	[PeopleId],
	[SCAName],
	[Registered],
	[Preferred]
FROM SCAAlias
WHERE
	[AliasId] = @AliasId
	
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAAliasDelete]    Script Date: 06/02/2010 22:32:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAliasDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAAliasDelete]
	@AliasId int
AS

DELETE FROM SCAAlias
WHERE
	[AliasId] = @AliasId
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAAliasAdd]    Script Date: 06/02/2010 22:32:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAliasAdd]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAAliasAdd]
	@PeopleId int,
	@SCAName nvarchar(300),
	@Registered bit,
	@Preferred bit
AS

INSERT INTO SCAAlias (
	[PeopleId],
	[SCAName],
	[Registered],
	[Preferred]
) VALUES (
	@PeopleId,
	@SCAName,
	@Registered,
	@Preferred
)

select SCOPE_IDENTITY()
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAAwardsUpdate]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAwardsUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAAwardsUpdate]
	@AwardId int, 
	@GroupId int, 
	@Name nvarchar(200), 
	@Charter ntext, 
	@Precedence int, 
	@SortOrder int,
	@BadgeUrl varchar(300), 
	@BadgeBlazon nvarchar(4000), 
	@Closed bit, 
	@AwardedById int,
	@AwardGroupId int,
	@Honorary bit	
AS

UPDATE SCAAwards SET
	[GroupId] = @GroupId,
	[Name] = @Name,
	[Charter] = @Charter,
	[Precedence] = @Precedence,
	[SortOrder] = @SortOrder,
	[BadgeUrl] = @BadgeUrl,
	[BadgeBlazon] = @BadgeBlazon,
	[Closed] = @Closed,
	[AwardedById] = @AwardedById,
	[AwardGroupId] = @AwardGroupId,
	[Honorary] = @Honorary
WHERE
	[AwardId] = @AwardId
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAAwardsListByGroup]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAwardsListByGroup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAAwardsListByGroup]
@GroupId int
AS

SELECT
	SCAAwards.AwardId,
	SCAAwards.GroupId,
	SCAAwards.Name,
	SCAAwards.Charter,
	SCAAwards.Precedence,
	SCAAwards.SortOrder,
	case when BadgeFiles.FileName is null then SCAAwards.BadgeUrl else BadgeFiles.Folder + BadgeFiles.FileName end as BadgeUrl,
	case when BadgeFiles.Width is null then 0 else BadgeFiles.Width end as BadgeUrlWidth,
	case when BadgeFiles.Height is null then 0 else BadgeFiles.Height end as BadgeUrlHeight,
	SCAAwards.BadgeBlazon,
	SCAAwards.Closed,
	SCAAwards.Honorary,
	SCAAwards.AwardedById,
	SCAAwards.AwardGroupId,
	SCAGroups.Name AS GroupName,
	SCAGroups.Name + '' -'' + SCAAwards.Name AS GroupAward,
	SCAAwardGroups.AwardGroupName,
    SCAAwards.Name as AwardName
FROM SCAAwards 
JOIN SCAGroups ON SCAAwards.GroupId = SCAGroups.GroupId
LEFT JOIN SCAAwardGroups ON SCAAwards.AwardGroupId = SCAAwardGroups.AwardGroupId
Left join Files BadgeFiles on SCAAwards.BadgeUrl = ''fileid='' + convert(varchar,BadgeFiles.FileID)
WHERE SCAAwards.GroupId  = @GroupId
ORDER BY GroupAward
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAAwardsList]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAwardsList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAAwardsList]
AS

SELECT
	SCAAwards.AwardId,
	SCAAwards.GroupId,
	SCAAwards.Name,
	SCAAwards.Charter,
	SCAAwards.Precedence,
	SCAAwards.SortOrder,
	case when BadgeFiles.FileName is null then SCAAwards.BadgeUrl else BadgeFiles.Folder + BadgeFiles.FileName end as BadgeUrl,
	case when BadgeFiles.Width is null then 0 else BadgeFiles.Width end as BadgeUrlWidth,
	case when BadgeFiles.Height is null then 0 else BadgeFiles.Height end as BadgeUrlHeight,
	SCAAwards.BadgeBlazon,
	SCAAwards.Closed,
	SCAAwards.Honorary,
	SCAAwards.AwardedById,
	SCAAwards.AwardGroupId,
	SCAGroups.Name AS GroupName,
	SCAGroups.Name + '' -'' + SCAAwards.Name AS GroupAward,
	SCAAwardGroups.AwardGroupName
FROM SCAAwards 
JOIN SCAGroups ON SCAAwards.GroupId = SCAGroups.GroupId
LEFT JOIN SCAAwardGroups ON SCAAwards.AwardGroupId = SCAAwardGroups.AwardGroupId
Left join Files BadgeFiles on SCAAwards.BadgeUrl = ''fileid='' + convert(varchar,BadgeFiles.FileID)
ORDER BY GroupAward
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAAwardsGetSameName]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAwardsGetSameName]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAAwardsGetSameName]
	@AwardId int,
	@ShowAll bit
AS

SELECT
	SCAAwards.AwardId,
	SCAAwards.GroupId,
	SCAAwards.Name,
	SCAAwards.Precedence,
	SCAAwards.SortOrder,
	SCAAwards.BadgeBlazon,
	SCAAwards.AwardedById,
	SCAAwards.AwardGroupId,
	SCAGroups.Name AS GroupName,
	SCAGroups.Name + '' -'' + SCAAwards.Name AS GroupAward,
	SCAAwardGroups.AwardGroupName,
	COUNT(*) as AwardeeCount
FROM SCAAwards 
JOIN SCAGroups ON SCAAwards.GroupId = SCAGroups.GroupId
LEFT JOIN SCAAwardGroups ON SCAAwards.AwardGroupId = SCAAwardGroups.AwardGroupId
JOin SCAPeopleAward on SCAPeopleAward.AwardId = SCAAwards.AwardId
WHERE (SCAAwards.Name 
		IN (SELECT otherAwards.Name from SCAAwards otherAwards WHERE otherAwards.Awardid = @awardid)
		AND (@ShowAll = 1 OR SCAAwards.AwardId <> @AwardId))
GROUP BY SCAAwards.AwardId, SCAAwards.GroupId, SCAAwards.Name, SCAAwards.Precedence, SCAAwards.SortOrder, SCAAwards.BadgeBlazon, 
                      SCAAwards.AwardedById, SCAAwards.AwardGroupId, SCAGroups.Name, SCAGroups.Name + '' -'' + SCAAwards.Name, 
                      SCAAwardGroups.AwardGroupName
	


' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAAwardsGetCountByTime]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAwardsGetCountByTime]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAAwardsGetCountByTime]
@GroupId int,
@TimeStart Datetime, 
@TimeEnd DateTime
AS
SELECT     dbo.SCAAwards.Name, count(*) as AwardCount
FROM         dbo.SCAPeopleAward INNER JOIN
                      dbo.SCAPeople ON dbo.SCAPeopleAward.PeopleId = dbo.SCAPeople.PeopleId INNER JOIN
                      dbo.SCAAwards ON dbo.SCAPeopleAward.AwardId = dbo.SCAAwards.AwardId

where ((SCAAwards.GroupId = @GroupId or @GroupId is Null) and (SCAPeopleAward.Date between @TimeStart and @TimeEnd)  )
Group By dbo.SCAAwards.Name, dbo.SCAAwards.Precedence,dbo.SCAAwards.SortOrder
Order By COALESCE(dbo.SCAAwards.Precedence, 1000 ), dbo.SCAAwards.SortOrder' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAAwardsGetCountByCrowns]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAwardsGetCountByCrowns]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAAwardsGetCountByCrowns]
	@CrownId int
AS
SELECT     dbo.SCAAwards.Name, count(*) as AwardCount
FROM         dbo.SCAPeopleAward INNER JOIN
                      dbo.SCAPeople ON dbo.SCAPeopleAward.PeopleId = dbo.SCAPeople.PeopleId INNER JOIN
                      dbo.SCAAwards ON dbo.SCAPeopleAward.AwardId = dbo.SCAAwards.AwardId

where SCAPeopleAward.CrownId = @CrownId
Group By dbo.SCAAwards.Name, dbo.SCAAwards.Precedence,dbo.SCAAwards.SortOrder
Order By COALESCE(dbo.SCAAwards.Precedence, 1000 ), dbo.SCAAwards.SortOrder' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAAwardYears]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAwardYears]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAAwardYears]
	
AS
select DISTINct (YEAR(DATE)) as Year from scapeopleaward
order by YEAR(DATE) desc' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAAwardGroupsGetSameName]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAwardGroupsGetSameName]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAAwardGroupsGetSameName]
	@AwardGroupId int,
	@ShowAll bit
AS

SELECT
	SCAAwardGroups.[AwardGroupId] as AwardId,
	SCAAwardGroups.[AwardGroupName],
	SCAAwardGroups.[Precedence],
	SCAAwardGroups.[SortOrder],
	SCAAwardGroups.[GroupId],
	SCAGroups.Name AS GroupName,
	COUNT(*) as AwardeeCount
FROM SCAAwardGroups 
JOIN SCAGroups ON SCAAwardGroups.GroupId = SCAGroups.GroupId
JOIN SCAAwards on SCAAwards.AwardGroupId = SCAAwardGroups.AwardGroupId
JOin SCAPeopleAward on SCAPeopleAward.AwardId = SCAAwards.AwardId
WHERE (AwardGroupName
		IN (SELECT otherAwards.[AwardGroupName] from SCAAwardGroups otherAwards WHERE otherAwards.[AwardGroupId] = @AwardGroupId)
		AND (@ShowAll = 1 OR SCAAwards.[AwardGroupId] <> @AwardGroupId))
GROUP BY SCAAwardGroups.[AwardGroupId],
	SCAAwardGroups.[AwardGroupName],
	SCAAwardGroups.[Precedence],
	SCAAwardGroups.[SortOrder],
	SCAAwardGroups.[GroupId],
	SCAGroups.Name


' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleAwardUpdate]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleAwardUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleAwardUpdate]
	@PeopleAwardId int, 
	@AwardId int, 
	@PeopleId int, 
	@Date datetime, 
	@CrownId int, 
	@Notes nvarchar(500), 
	@AliasId int,
	@Retired bit
AS
WHILE EXISTS (SELECT * FROM scapeopleaward where peopleid = @peopleid and date=@Date and PeopleAwardid<> @PeopleAwardId)
BEGIN
	SET @Date =  DateAdd(hh,1,@Date)
END
UPDATE SCAPeopleAward SET
	[AwardId] = @AwardId,
	[PeopleId] = @PeopleId,
	[Date] = @Date,
	[CrownId] = @CrownId,
	[Notes] = @Notes,
	[AliasId] = @AliasId,
	[Retired] = @Retired
WHERE
	[PeopleAwardId] = @PeopleAwardId

' 
END
GO
/****** Object:  View {databaseOwner}.{objectQualifier}[SCAPeopleAwardPrecedence]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleAwardPrecedence]'))
EXEC dbo.sp_executesql @statement = N'
CREATE    VIEW {databaseOwner}.{objectQualifier}[SCAPeopleAwardPrecedence]
AS

WITH ParentKingdom(GroupId, ParentKingdom) AS 
(SELECT     GroupId, GroupId AS ParentKingdom
         FROM         dbo.SCAGroups
         WHERE     (ParentGroupId IS NULL)
         UNION ALL
         SELECT     SCAGroups.GroupId, ParentKingdom.ParentKingdom
         FROM         dbo.SCAGroups 
					JOIN ParentKingdom ON SCAGroups.ParentGroupId = ParentKingdom.GroupId)
    --Select * from ParentKingdom

--Sovereign of Atenveldt
SELECT     
SCAPeople.[PeopleId],
CASE GENDER WHEN ''M'' THEN ''King'' WHEN ''F'' THEN ''Queen'' ELSE ''Sovereign'' END AS HighestAwardName, 
SCAPeople.[SCAName],
1 AS HighestAwardPrecedence, 
SCACrowns.StartDate AS HighestAwardDate, 
-1 as HighestAwardId,
SCACrowns.CrownId
FROM         SCAPeople JOIN
                      SCACrowns ON SCAPeople.PeopleId = SovereignId
WHERE     Reign =
                          (SELECT     MAX(reign)
                            FROM          SCACrowns
                            WHERE      SCACrowns.GroupId = 26 AND Heir =0) AND SCACrowns.GroupId = 26
			AND Heir =0
UNION
--Consort of Atenveldt
SELECT     
SCAPeople.[PeopleId],
CASE GENDER WHEN ''M'' THEN ''Consort'' WHEN ''F'' THEN ''Queen'' ELSE ''Consort'' END AS HighestAwardName, 
SCAPeople.[SCAName],
2 AS HighestAwardPrecedence, 
SCACrowns.StartDate AS HighestAwardDate, 
-1 as HighestAwardId,
SCACrowns.CrownId
FROM         SCAPeople JOIN
                      SCACrowns ON SCAPeople.PeopleId = ConsortId
WHERE     Reign =
                          (SELECT     MAX(reign)
                            FROM          SCACrowns
                            WHERE      SCACrowns.GroupId = 26 AND Heir =0) AND SCACrowns.GroupId = 26
			AND Heir =0
UNION
 --Sovereign Heir of Atenveldt
SELECT     
SCAPeople.[PeopleId], 
CASE GENDER WHEN ''M'' THEN ''Crown Prince'' WHEN ''F'' THEN ''Crown Princess'' ELSE ''Sovereign Heir'' END AS HighestAwardName, 
SCAPeople.[SCAName], 
3 AS HighestAwardPrecedence, 
SCACrowns.StartDate AS HighestAwardDate,
 -1 as HighestAwardId,
SCACrowns.CrownId
FROM         SCAPeople JOIN
                      SCACrowns ON SCAPeople.PeopleId = SovereignId
WHERE     Reign =
                          (SELECT     MAX(reign)
                            FROM          SCACrowns
                            WHERE      SCACrowns.GroupId = 26 AND Heir =1) AND SCACrowns.GroupId = 26
			AND Heir =1
UNION
--Consort Heir of Atenveldt
SELECT     
SCAPeople.[PeopleId],
 CASE GENDER WHEN ''M'' THEN ''Consort Heir'' WHEN ''F'' THEN ''Crown Princess'' ELSE ''Consort Heir'' END AS HighestAwardName, 
SCAPeople.[SCAName], 
4 AS HighestAwardPrecedence, 
SCACrowns.StartDate AS HighestAwardDate, 
-1 as HighestAwardId,SCACrowns.CrownId
FROM         SCAPeople JOIN
                      SCACrowns ON SCAPeople.PeopleId = ConsortId
join scagroups branchresidence on SCAPeople.BranchResidenceId = branchresidence.GroupId
LEFT JOIN ParentKingdom on BranchResidenceId = ParentKingdom.GroupId
WHERE     Reign =
                          (SELECT     MAX(reign)
                            FROM          SCACrowns
                            WHERE      SCACrowns.GroupId = 26 AND Heir =1) AND SCACrowns.GroupId = 26
			AND Heir =1
UNION
-- Landed Baronies
SELECT     
SCAPeople.[PeopleId], 
CASE GENDER WHEN ''M'' THEN SCAGroups.SovereignMaleTitle + '' of '' + SCAGroups.Name WHEN ''F'' THEN SCAGroups.SovereignFemaleTitle + '' of '' + SCAGroups.Name ELSE ''Coronet of '' + SCAGroups.Name END AS HighestAwardName, 
SCAPeople.[SCAName], 
(SCAGroups.Precedence * 2 - 150) + CASE WHEN SCAPeople.PeopleId = SCACrowns.SovereignID THEN 0 ELSE 1 END AS HighestAwardPrecedence,
SCACrowns.StartDate AS HighestAwardDate, 
-1 as HighestAwardId,
SCACrowns.CrownId
FROM         SCAPeople JOIN
                      SCACrowns ON SCAPeople.PeopleId = SovereignID OR SCAPeople.PeopleId = ConsortId JOIN
                      SCAGROUps ON SCACrowns.GroupId = SCAGROUps.groupid
WHERE     SCAGROUPS.BranchStatusId = 1 AND SCACROWNS.groupid IN (Select GroupId from SCAGROUPS WHERE ParentGroupId=26) AND SCACrowns.CrownId =
                          (SELECT     crownid
                            FROM          scacrowns wcrn
                            WHERE      wcrn.groupid = SCACrowns.groupid AND Heir=0 AND wcrn.reign =
                                                       (SELECT     MAX(reign)
                                                         FROM          scacrowns w2crn
                                                         WHERE      w2crn.groupid = SCACrowns.groupid AND Heir=0))
UNION
-- Everyone Else
SELECT DISTINCT 
SCAPeople.[PeopleId], 
SCAAwards.Name AS HighestAwardName, 
SCAPeople.[SCAName], 
CASE WHEN SCAAwards.Precedence IS NULL OR Deceased=1 OR ParentKingdom<>26 THEN 1000 ELSE SCAAwards.Precedence END AS HighestAwardPrecedence, 
SCAPeopleAward.Date AS HighestAwardDate, 
SCAPeopleAward.AwardId as HighestAwardId, 
NULL as CrownId
FROM         SCAPeople 
LEFT JOIN dbo.SCAPeopleAward ON SCAPEopleAward.PeopleId = SCAPeople.PeopleId 
LEFT JOIN dbo.SCAAwards ON dbo.SCAPeopleAward.AwardId = dbo.SCAAwards.AwardId
LEFT JOIN ParentKingdom on BranchResidenceId = ParentKingdom.GroupId
WHERE   
--Only the highest award (prevents listing a person multiple times if they have multiple awards):
 (( CASE WHEN SCAAwards.Precedence IS NULL THEN 1000 ELSE SCAAwards.Precedence END =
                          (SELECT     MIN(CASE WHEN Precedence IS NULL THEN 1000 ELSE Precedence END)
                            FROM          SCAAwards wA JOIN
                                                   SCAPeopleAward wPA ON wPA.Awardid = wA.AwardId
                            WHERE      wpa.PeopleId = SCAPeople.PeopleId AND wpa.Retired = 0
                            GROUP BY wpa.Peopleid) 
 -- and date of highest award (prevents listing a person multiple times if they have multiple awards):
AND (SCAPeopleAward.Date = (SELECT     MIN(Date)
                            FROM          SCAAwards w2A  JOIN
                                                   SCAPeopleAward w2PA ON w2PA.Awardid = w2A.AwardId
                            WHERE      w2pa.PeopleId = SCAPeople.PeopleId AND CASE WHEN w2a.precedence IS NULL THEN 1000 ELSE w2a.precedence END =
                                                       (SELECT     MIN(CASE WHEN Precedence IS NULL THEN 1000 ELSE Precedence END)
                                                         FROM          SCAAwards wA JOIN
                                                                                SCAPeopleAward wPA ON wPA.Awardid = wA.AwardId
                                                         WHERE      wpa.PeopleId = SCAPeople.PeopleId AND wpa.Retired = 0
                                                         GROUP BY wpa.Peopleid)
                            GROUP BY w2pa.Peopleid)))
-- Include People without an award at all:
OR NOT Exists (SELECT     wpa.Peopleid 
                            FROM          SCAAwards wA  JOIN
                                                   SCAPeopleAward wPA ON wPA.Awardid = wA.AwardId
                            WHERE      wpa.PeopleId = SCAPeople.PeopleId AND wpa.Retired = 0
                            GROUP BY wpa.Peopleid))
-- and make sure they aren''t in one of the other UNIONED groups:
						AND SCAPeople.PeopleId NOT IN
                          (SELECT     SCAPeople.[PeopleId]
                            FROM          SCAPeople JOIN
                                                   SCACrowns ON SCAPeople.PeopleId = SovereignId
                            WHERE      Reign =
                                                      (SELECT     MAX(reign)
				                            FROM          SCACrowns
				                            WHERE      GroupId = 26 AND Heir =0) AND GroupId = 26
					AND Heir = 0
                            UNION
                            SELECT     SCAPeople.[PeopleId]
                            FROM         SCAPeople JOIN
                                                  SCACrowns ON SCAPeople.PeopleId = ConsortId
                            WHERE     Reign =
                                                      (SELECT     MAX(reign)
				                            FROM          SCACrowns
				                            WHERE      GroupId = 26 AND Heir =0) AND GroupId = 26
					AND Heir = 0
                            UNION
			    SELECT     SCAPeople.[PeopleId]
                            FROM          SCAPeople JOIN
                                                   SCACrowns ON SCAPeople.PeopleId = SovereignId
                            WHERE      Reign =
                                                      (SELECT     MAX(reign)
				                            FROM          SCACrowns
				                            WHERE      GroupId = 26 AND Heir =1) AND GroupId = 26
					AND Heir = 1
                            UNION
                            SELECT     SCAPeople.[PeopleId]
                            FROM         SCAPeople JOIN
                                                  SCACrowns ON SCAPeople.PeopleId = ConsortId
                            WHERE     Reign =
                                                      (SELECT     MAX(reign)
				                            FROM          SCACrowns
				                            WHERE      GroupId = 26 AND Heir =1) AND GroupId = 26
					AND Heir = 1
                            UNION
                            SELECT     SCAPeople.[PeopleId]
                            FROM         SCAPeople JOIN
                                                  SCACrowns ON SCAPeople.PeopleId = SovereignID OR SCAPeople.PeopleId = ConsortId JOIN
                                                  SCAGROUps ON SCACrowns.GroupId = SCAGROUps.groupid
                            WHERE     SCAGROUPS.BranchStatusId = 1 AND SCACROWNS.groupid IN (Select GroupId from SCAGROUPS WHERE ParentGroupId=26) AND SCACrowns.CrownId =
                                                      (SELECT     crownid
                                                        FROM          scacrowns wcrn
                                                        WHERE      wcrn.groupid = SCACrowns.groupid AND Heir=0 AND wcrn.reign =
                                                                                   (SELECT     MAX(reign)
                                                                                     FROM          scacrowns w2crn
                                                                                     WHERE      w2crn.groupid = SCACrowns.groupid AND Heir=0)))
'
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleAwardList]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleAwardList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleAwardList]
AS

SELECT
	[PeopleAwardId],
	[AwardId],
	[PeopleId],
	[Date],
	[CrownId],
	[Notes],
	[AliasId]
FROM SCAPeopleAward
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleAwardGetByTime]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleAwardGetByTime]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleAwardGetByTime]
@GroupId int,	
@TimeStart Datetime, 
@TimeEnd DateTime
AS


SELECT
	SCAPeopleAward.PeopleAwardId,
	SCAPeopleAward.AwardId,
	SCAPeopleAward.PeopleId,
	SCAPeopleAward.Date,
	SCAPeopleAward.CrownId,
	CASE SCAAwards.AwardedById 
	WHEN 1 THEN 
		CASE WHEN LEFT(S.SCAName,
		CASE WHEN PATINDEX(''% %'',S.SCAName)>0 THEN PATINDEX(''% %'',S.SCAName) -1 ELSE 0 END) = '''' THEN S.SCAName ELSE LEFT(S.SCAName,
		CASE WHEN PATINDEX(''% %'',S.SCAName)>0 THEN PATINDEX(''% %'',S.SCAName) -1 ELSE 0 END) END + '' and '' + CASE WHEN LEFT(C.SCAName,
		CASE WHEN PATINDEX(''% %'',C.SCAName)>0 THEN PATINDEX(''% %'',C.SCAName) -1 ELSE 0 END) = '''' THEN C.SCAName ELSE LEFT(C.SCAName,
		CASE WHEN PATINDEX(''% %'',C.SCAName)>0 THEN PATINDEX(''% %'',C.SCAName) -1 ELSE 0 END) END 
	WHEN 2 THEN 
		CASE WHEN LEFT(S.SCAName,
		CASE WHEN PATINDEX(''% %'',S.SCAName)>0 THEN PATINDEX(''% %'',S.SCAName) -1 ELSE 0 END) = '''' THEN S.SCAName ELSE LEFT(S.SCAName,
		CASE WHEN PATINDEX(''% %'',S.SCAName)>0 THEN PATINDEX(''% %'',S.SCAName) -1 ELSE 0 END) END 
	WHEN 3 THEN 
		CASE WHEN LEFT(C.SCAName,
		CASE WHEN PATINDEX(''% %'',C.SCAName)>0 THEN PATINDEX(''% %'',C.SCAName) -1 ELSE 0 END) = '''' THEN C.SCAName ELSE LEFT(C.SCAName,
		CASE WHEN PATINDEX(''% %'',C.SCAName)>0 THEN PATINDEX(''% %'',C.SCAName) -1 ELSE 0 END) END 
	END AS AwardedBy,
	SCACrowns.StartDate as CrownStartDate,
	SCACrowns.EndDate as CrownEndDate,
	SCACrowns.Reign,
	SCAPeopleAward.Notes,
	SCAPeopleAward.AliasId,
	SCAPeople.SCAName,
	A.SCAName AS NameOnScroll,
	SCAAwards.Name AS AwardName,
	SCAPeopleAward.Retired,
	SCAAwards.Precedence,
	SCAAwards.Honorary,
	SCAGroups.Name AS GroupName,
	SCAGroups.GroupId as GroupId,
	CASE WHEN SCAAwards.AwardGroupId IS NULL then ''aid'' Else ''gaid'' END as AwardType
FROM SCAPeopleAward
JOIN SCAAwards ON SCAAwards.AwardId = SCAPeopleAward.AwardId
JOIN SCAGroups ON SCAAwards.GroupId = SCAGroups.GroupId
JOIN SCAPeople ON SCAPeople.PeopleId = SCAPeopleAward.PeopleId
LEFT JOIN SCACrowns ON SCAPeopleAward.CrownId = SCACrowns.CrownId
LEFT JOIN SCAPeople C ON SCACrowns.ConsortId = C.PeopleId
LEFT JOIN SCAPeople S ON SCACrowns.SovereignId = S.PeopleId
LEFT JOIN SCAAlias A ON SCAPeopleAward.AliasId = A.AliasId
WHERE ((SCAAwards.GroupId = @GroupId or @GroupId is Null) and (SCAPeopleAward.Date between @TimeStart and @TimeEnd)  )
ORDER BY SCAPeopleAward.Date , CASE WHEN SCAAwards.Precedence IS NULL THEN 1000 ELSE SCAAwards.Precedence END' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleAwardGetByPeople]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleAwardGetByPeople]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleAwardGetByPeople]
	@PeopleId int
AS
SELECT
	SCAPeopleAward.PeopleAwardId,
	SCAPeopleAward.AwardId,
	SCAPeopleAward.PeopleId,
	SCAPeopleAward.Date,
	SCAPeopleAward.CrownId,
	CASE SCAAwards.AwardedById 
	WHEN 1 THEN 
		CASE WHEN LEFT(S.SCAName,
		CASE WHEN PATINDEX(''% %'',S.SCAName)>0 THEN PATINDEX(''% %'',S.SCAName) -1 ELSE 0 END) = '''' THEN S.SCAName ELSE LEFT(S.SCAName,
		CASE WHEN PATINDEX(''% %'',S.SCAName)>0 THEN PATINDEX(''% %'',S.SCAName) -1 ELSE 0 END) END + '' and '' + CASE WHEN LEFT(C.SCAName,
		CASE WHEN PATINDEX(''% %'',C.SCAName)>0 THEN PATINDEX(''% %'',C.SCAName) -1 ELSE 0 END) = '''' THEN C.SCAName ELSE LEFT(C.SCAName,
		CASE WHEN PATINDEX(''% %'',C.SCAName)>0 THEN PATINDEX(''% %'',C.SCAName) -1 ELSE 0 END) END 
	WHEN 2 THEN 
		CASE WHEN LEFT(S.SCAName,
		CASE WHEN PATINDEX(''% %'',S.SCAName)>0 THEN PATINDEX(''% %'',S.SCAName) -1 ELSE 0 END) = '''' THEN S.SCAName ELSE LEFT(S.SCAName,
		CASE WHEN PATINDEX(''% %'',S.SCAName)>0 THEN PATINDEX(''% %'',S.SCAName) -1 ELSE 0 END) END 
	WHEN 3 THEN 
		CASE WHEN LEFT(C.SCAName,
		CASE WHEN PATINDEX(''% %'',C.SCAName)>0 THEN PATINDEX(''% %'',C.SCAName) -1 ELSE 0 END) = '''' THEN C.SCAName ELSE LEFT(C.SCAName,
		CASE WHEN PATINDEX(''% %'',C.SCAName)>0 THEN PATINDEX(''% %'',C.SCAName) -1 ELSE 0 END) END 
	END AS AwardedBy,
	SCAPeopleAward.Notes,
	SCAPeopleAward.AliasId,
	SCAPeople.SCAName,
	A.SCAName AS NameOnScroll,
	SCAAwards.Name AS AwardName,
	SCAPeopleAward.Retired,
	SCAAwards.Precedence,
	SCAAwards.Honorary,
	SCAGroups.Name AS GroupName,
	SCAGroups.GroupId as GroupId
FROM SCAPeopleAward
JOIN SCAAwards ON SCAAwards.AwardId = SCAPeopleAward.AwardId
JOIN SCAGroups ON SCAAwards.GroupId = SCAGroups.GroupId
JOIN SCAPeople ON SCAPeople.PeopleId = SCAPeopleAward.PeopleId
LEFT JOIN SCACrowns ON SCAPeopleAward.CrownId = SCACrowns.CrownId
LEFT JOIN SCAPeople C ON SCACrowns.ConsortId = C.PeopleId
LEFT JOIN SCAPeople S ON SCACrowns.SovereignId = S.PeopleId
LEFT JOIN SCAAlias A ON SCAPeopleAward.AliasId = A.AliasId
WHERE (SCAPeopleAward.PeopleId = @PeopleId)
ORDER BY CASE WHEN SCAAwards.Precedence IS NULL THEN 1000 ELSE SCAAwards.Precedence END,
	SCAPeopleAward.Date 
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleAwardGetByCrowns]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleAwardGetByCrowns]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleAwardGetByCrowns]
	@CrownId int
AS
DECLARE @GROUPID int, @CrownStart Datetime, @CrownEnd DateTime
SELECT @GroupId = GroupId, @CrownStart = StartDate, @CrownEnd = EndDate from SCACrowns where CrownId = @CrownId

SELECT
	SCAPeopleAward.PeopleAwardId,
	SCAPeopleAward.AwardId,
	SCAPeopleAward.PeopleId,
	SCAPeopleAward.Date,
	SCAPeopleAward.CrownId,
	CASE SCAAwards.AwardedById 
	WHEN 1 THEN 
		CASE WHEN LEFT(S.SCAName,
		CASE WHEN PATINDEX(''% %'',S.SCAName)>0 THEN PATINDEX(''% %'',S.SCAName) -1 ELSE 0 END) = '''' THEN S.SCAName ELSE LEFT(S.SCAName,
		CASE WHEN PATINDEX(''% %'',S.SCAName)>0 THEN PATINDEX(''% %'',S.SCAName) -1 ELSE 0 END) END + '' and '' + CASE WHEN LEFT(C.SCAName,
		CASE WHEN PATINDEX(''% %'',C.SCAName)>0 THEN PATINDEX(''% %'',C.SCAName) -1 ELSE 0 END) = '''' THEN C.SCAName ELSE LEFT(C.SCAName,
		CASE WHEN PATINDEX(''% %'',C.SCAName)>0 THEN PATINDEX(''% %'',C.SCAName) -1 ELSE 0 END) END 
	WHEN 2 THEN 
		CASE WHEN LEFT(S.SCAName,
		CASE WHEN PATINDEX(''% %'',S.SCAName)>0 THEN PATINDEX(''% %'',S.SCAName) -1 ELSE 0 END) = '''' THEN S.SCAName ELSE LEFT(S.SCAName,
		CASE WHEN PATINDEX(''% %'',S.SCAName)>0 THEN PATINDEX(''% %'',S.SCAName) -1 ELSE 0 END) END 
	WHEN 3 THEN 
		CASE WHEN LEFT(C.SCAName,
		CASE WHEN PATINDEX(''% %'',C.SCAName)>0 THEN PATINDEX(''% %'',C.SCAName) -1 ELSE 0 END) = '''' THEN C.SCAName ELSE LEFT(C.SCAName,
		CASE WHEN PATINDEX(''% %'',C.SCAName)>0 THEN PATINDEX(''% %'',C.SCAName) -1 ELSE 0 END) END 
	END AS AwardedBy,
	SCACrowns.StartDate as CrownStartDate,
	SCACrowns.EndDate as CrownEndDate,
	SCACrowns.Reign,
	SCAPeopleAward.Notes,
	SCAPeopleAward.AliasId,
	SCAPeople.SCAName,
	A.SCAName AS NameOnScroll,
	SCAAwards.Name AS AwardName,
	SCAPeopleAward.Retired,
	SCAAwards.Precedence,
	SCAAwards.Honorary,
	SCAGroups.Name AS GroupName,
	SCAGroups.GroupId as GroupId
FROM SCAPeopleAward
JOIN SCAAwards ON SCAAwards.AwardId = SCAPeopleAward.AwardId
JOIN SCAGroups ON SCAAwards.GroupId = SCAGroups.GroupId
JOIN SCAPeople ON SCAPeople.PeopleId = SCAPeopleAward.PeopleId
LEFT JOIN SCACrowns ON SCAPeopleAward.CrownId = SCACrowns.CrownId
LEFT JOIN SCAPeople C ON SCACrowns.ConsortId = C.PeopleId
LEFT JOIN SCAPeople S ON SCACrowns.SovereignId = S.PeopleId
LEFT JOIN SCAAlias A ON SCAPeopleAward.AliasId = A.AliasId
WHERE (SCACrowns.CrownId = @CrownId)
ORDER BY SCAPeopleAward.Date , CASE WHEN SCAAwards.Precedence IS NULL THEN 1000 ELSE SCAAwards.Precedence END
	

SELECT
	SCAPeopleAward.PeopleAwardId,
	SCAPeopleAward.AwardId,
	SCAPeopleAward.PeopleId,
	SCAPeopleAward.Date,
	SCAPeopleAward.CrownId,
	CASE SCAAwards.AwardedById 
	WHEN 1 THEN 
		CASE WHEN LEFT(S.SCAName,
		CASE WHEN PATINDEX(''% %'',S.SCAName)>0 THEN PATINDEX(''% %'',S.SCAName) -1 ELSE 0 END) = '''' THEN S.SCAName ELSE LEFT(S.SCAName,
		CASE WHEN PATINDEX(''% %'',S.SCAName)>0 THEN PATINDEX(''% %'',S.SCAName) -1 ELSE 0 END) END + '' and '' + CASE WHEN LEFT(C.SCAName,
		CASE WHEN PATINDEX(''% %'',C.SCAName)>0 THEN PATINDEX(''% %'',C.SCAName) -1 ELSE 0 END) = '''' THEN C.SCAName ELSE LEFT(C.SCAName,
		CASE WHEN PATINDEX(''% %'',C.SCAName)>0 THEN PATINDEX(''% %'',C.SCAName) -1 ELSE 0 END) END 
	WHEN 2 THEN 
		CASE WHEN LEFT(S.SCAName,
		CASE WHEN PATINDEX(''% %'',S.SCAName)>0 THEN PATINDEX(''% %'',S.SCAName) -1 ELSE 0 END) = '''' THEN S.SCAName ELSE LEFT(S.SCAName,
		CASE WHEN PATINDEX(''% %'',S.SCAName)>0 THEN PATINDEX(''% %'',S.SCAName) -1 ELSE 0 END) END 
	WHEN 3 THEN 
		CASE WHEN LEFT(C.SCAName,
		CASE WHEN PATINDEX(''% %'',C.SCAName)>0 THEN PATINDEX(''% %'',C.SCAName) -1 ELSE 0 END) = '''' THEN C.SCAName ELSE LEFT(C.SCAName,
		CASE WHEN PATINDEX(''% %'',C.SCAName)>0 THEN PATINDEX(''% %'',C.SCAName) -1 ELSE 0 END) END 
	END AS AwardedBy,
	SCACrowns.StartDate as CrownStartDate,
	SCACrowns.EndDate as CrownEndDate,
	SCACrowns.Reign,
	SCAPeopleAward.Notes,
	SCAPeopleAward.AliasId,
	SCAPeople.SCAName,
	A.SCAName AS NameOnScroll,
	SCAAwards.Name AS AwardName,
	SCAPeopleAward.Retired,
	SCAAwards.Precedence,
	SCAGroups.Name AS GroupName,
	SCAGroups.GroupId as GroupId
FROM SCAPeopleAward
JOIN SCAAwards ON SCAAwards.AwardId = SCAPeopleAward.AwardId
JOIN SCAGroups ON SCAAwards.GroupId = SCAGroups.GroupId
JOIN SCAPeople ON SCAPeople.PeopleId = SCAPeopleAward.PeopleId
LEFT JOIN SCACrowns ON SCAPeopleAward.CrownId = SCACrowns.CrownId
LEFT JOIN SCAPeople C ON SCACrowns.ConsortId = C.PeopleId
LEFT JOIN SCAPeople S ON SCACrowns.SovereignId = S.PeopleId
LEFT JOIN SCAAlias A ON SCAPeopleAward.AliasId = A.AliasId
WHERE (SCAAwards.GroupId = @GroupId and (SCAPeopleAward.Date between @CrownStart and @CrownEnd) and SCAPeopleAward.CrownId is null )
ORDER BY SCAPeopleAward.Date , CASE WHEN SCAAwards.Precedence IS NULL THEN 1000 ELSE SCAAwards.Precedence END' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleAwardGetByAwards]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleAwardGetByAwards]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleAwardGetByAwards]
	@AwardId int,
	@SameName bit
AS

SELECT
	SCAPeopleAward.PeopleAwardId,
	SCAPeopleAward.AwardId,
	SCAPeopleAward.PeopleId,
	SCAPeopleAward.Date,
	SCAPeopleAward.CrownId,
	CASE SCAAwards.AwardedById 
	WHEN 1 THEN 
		CASE WHEN LEFT(S.SCAName,
		CASE WHEN PATINDEX(''% %'',S.SCAName)>0 THEN PATINDEX(''% %'',S.SCAName) -1 ELSE 0 END) = '''' THEN S.SCAName ELSE LEFT(S.SCAName,
		CASE WHEN PATINDEX(''% %'',S.SCAName)>0 THEN PATINDEX(''% %'',S.SCAName) -1 ELSE 0 END) END + '' and '' + CASE WHEN LEFT(C.SCAName,
		CASE WHEN PATINDEX(''% %'',C.SCAName)>0 THEN PATINDEX(''% %'',C.SCAName) -1 ELSE 0 END) = '''' THEN C.SCAName ELSE LEFT(C.SCAName,
		CASE WHEN PATINDEX(''% %'',C.SCAName)>0 THEN PATINDEX(''% %'',C.SCAName) -1 ELSE 0 END) END 
	WHEN 2 THEN 
		CASE WHEN LEFT(S.SCAName,
		CASE WHEN PATINDEX(''% %'',S.SCAName)>0 THEN PATINDEX(''% %'',S.SCAName) -1 ELSE 0 END) = '''' THEN S.SCAName ELSE LEFT(S.SCAName,
		CASE WHEN PATINDEX(''% %'',S.SCAName)>0 THEN PATINDEX(''% %'',S.SCAName) -1 ELSE 0 END) END 
	WHEN 3 THEN 
		CASE WHEN LEFT(C.SCAName,
		CASE WHEN PATINDEX(''% %'',C.SCAName)>0 THEN PATINDEX(''% %'',C.SCAName) -1 ELSE 0 END) = '''' THEN C.SCAName ELSE LEFT(C.SCAName,
		CASE WHEN PATINDEX(''% %'',C.SCAName)>0 THEN PATINDEX(''% %'',C.SCAName) -1 ELSE 0 END) END 
	END AS AwardedBy,
	SCAPeopleAward.Notes,
	SCAPeopleAward.AliasId,
	SCAPeople.SCAName,
	A.SCAName AS NameOnScroll,
	SCAAwards.Name AS AwardName,
	SCAPeopleAward.Retired,
	SCAAwards.Precedence,
	SCAAwards.Honorary,
	SCAGroups.Name AS GroupName,
	SCAGroups.GroupId as GroupId,
	SCAPeople.ArmsUrl,
	SCAPeople.ShowPicPermission,
	SCAPeople.PhotoURL
FROM SCAPeopleAward 
JOIN SCAAwards ON SCAAwards.AwardId = SCAPeopleAward.AwardId 
JOIN SCAGroups ON SCAAwards.GroupId = SCAGroups.GroupId
JOIN SCAPeople ON SCAPeople.PeopleId = SCAPeopleAward.PeopleId
LEFT JOIN SCACrowns ON SCAPeopleAward.CrownId = SCACrowns.CrownId
LEFT JOIN SCAPeople C ON SCACrowns.ConsortId = C.PeopleId
LEFT JOIN SCAPeople S ON SCACrowns.SovereignId = S.PeopleId
LEFT JOIN SCAAlias A ON SCAPeopleAward.AliasId = A.AliasId
WHERE (SCAPeopleAward.AwardId = @AwardId) OR (@SameName = 1 AND SCAAwards.Name 
		IN (SELECT otherAwards.Name from SCAAwards otherAwards WHERE otherAwards.Awardid = @awardid))
ORDER BY SCAPeopleAward.Date 


' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleAwardGetByAwardGroup]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleAwardGetByAwardGroup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleAwardGetByAwardGroup]
	@AwardGroupId int,
	@SameName bit
AS

SELECT
	SCAPeopleAward.PeopleAwardId,
	SCAPeopleAward.AwardId,
	SCAPeopleAward.PeopleId,
	SCAPeopleAward.Date,
	SCAPeopleAward.CrownId,
	CASE SCAAwards.AwardedById 
	WHEN 1 THEN 
		CASE WHEN LEFT(S.SCAName,
		CASE WHEN PATINDEX(''% %'',S.SCAName)>0 THEN PATINDEX(''% %'',S.SCAName) -1 ELSE 0 END) = '''' THEN S.SCAName ELSE LEFT(S.SCAName,
		CASE WHEN PATINDEX(''% %'',S.SCAName)>0 THEN PATINDEX(''% %'',S.SCAName) -1 ELSE 0 END) END + '' and '' + CASE WHEN LEFT(C.SCAName,
		CASE WHEN PATINDEX(''% %'',C.SCAName)>0 THEN PATINDEX(''% %'',C.SCAName) -1 ELSE 0 END) = '''' THEN C.SCAName ELSE LEFT(C.SCAName,
		CASE WHEN PATINDEX(''% %'',C.SCAName)>0 THEN PATINDEX(''% %'',C.SCAName) -1 ELSE 0 END) END 
	WHEN 2 THEN 
		CASE WHEN LEFT(S.SCAName,
		CASE WHEN PATINDEX(''% %'',S.SCAName)>0 THEN PATINDEX(''% %'',S.SCAName) -1 ELSE 0 END) = '''' THEN S.SCAName ELSE LEFT(S.SCAName,
		CASE WHEN PATINDEX(''% %'',S.SCAName)>0 THEN PATINDEX(''% %'',S.SCAName) -1 ELSE 0 END) END 
	WHEN 3 THEN 
		CASE WHEN LEFT(C.SCAName,
		CASE WHEN PATINDEX(''% %'',C.SCAName)>0 THEN PATINDEX(''% %'',C.SCAName) -1 ELSE 0 END) = '''' THEN C.SCAName ELSE LEFT(C.SCAName,
		CASE WHEN PATINDEX(''% %'',C.SCAName)>0 THEN PATINDEX(''% %'',C.SCAName) -1 ELSE 0 END) END 
	END AS AwardedBy,
	SCAPeopleAward.Notes,
	SCAPeopleAward.AliasId,
	SCAPeople.SCAName,
	A.SCAName AS NameOnScroll,
	SCAAwards.Name AS AwardName,
	SCAPeopleAward.Retired,
	SCAAwards.Precedence,
	SCAAwards.Honorary,
	SCAGroups.Name AS GroupName,
	SCAGroups.GroupId as GroupId,
	SCAPeople.ArmsUrl,
	SCAPeople.ShowPicPermission,
	SCAPeople.PhotoURL
FROM SCAPeopleAward 
JOIN SCAAwards ON SCAAwards.AwardId = SCAPeopleAward.AwardId 
JOIN SCAGroups ON SCAAwards.GroupId = SCAGroups.GroupId
JOIN SCAPeople ON SCAPeople.PeopleId = SCAPeopleAward.PeopleId
LEFT JOIN SCACrowns ON SCAPeopleAward.CrownId = SCACrowns.CrownId
LEFT JOIN SCAPeople C ON SCACrowns.ConsortId = C.PeopleId
LEFT JOIN SCAPeople S ON SCACrowns.SovereignId = S.PeopleId
LEFT JOIN SCAAlias A ON SCAPeopleAward.AliasId = A.AliasId
WHERE (SCAAwards.AwardGroupId =@AwardGroupId) OR (@SameName = 1 AND SCAAwards.Name 
		IN (SELECT otherAwards.Name from SCAAwards otherAwards WHERE otherAwards.AwardGroupId = @AwardGroupId))
ORDER BY SCAPeopleAward.Date


' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleAwardGetByAlias]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleAwardGetByAlias]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleAwardGetByAlias]
	@AliasId int
AS

SELECT
	[PeopleAwardId],
	[AwardId],
	[PeopleId],
	[Date],
	[CrownId],
	[Notes],
	[AliasId]
FROM SCAPeopleAward
WHERE
	[AliasId]=@AliasId
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleAwardGet]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleAwardGet]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleAwardGet]
	@PeopleAwardId int
	
AS

SELECT
	[PeopleAwardId],
	[AwardId],
	[PeopleId],
	[Date],
	[CrownId],
	[Notes],
	[AliasId]
FROM SCAPeopleAward
WHERE
	[PeopleAwardId] = @PeopleAwardId
	
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleAwardDelete]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleAwardDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleAwardDelete]
	@PeopleAwardId int
AS

DELETE FROM SCAPeopleAward
WHERE
	[PeopleAwardId] = @PeopleAwardId
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleAwardAdd]    Script Date: 06/02/2010 22:32:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleAwardAdd]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleAwardAdd]
	@AwardId int,
	@PeopleId int,
	@Date datetime,
	@CrownId int,
	@Notes nvarchar(500),
	@AliasId int,
	@Retired bit
AS
WHILE EXISTS (SELECT * FROM scapeopleaward where peopleid = @peopleid and date=@Date)
BEGIN
	SET @Date =  DateAdd(hh,1,@Date)
END
INSERT INTO SCAPeopleAward (
	[AwardId],
	[PeopleId],
	[Date],
	[CrownId],
	[Notes],
	[AliasId],
	[Retired]
) VALUES (
	@AwardId,
	@PeopleId,
	@Date,
	@CrownId,
	@Notes,
	@AliasId,
	@Retired
)

select SCOPE_IDENTITY()

' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleDelete]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleDelete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleDelete]
	@PeopleId int
AS
DELETE from SCAAlias where PeopleId = @PeopleId
DELETE from Scapeopleaward where PeopleId = @PeopleId
DELETE FROM SCAPeople
WHERE
	[PeopleId] = @PeopleId
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleListGame]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleListGame]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleListGame] 
@Difficulty int, 
@GameType varchar(20)

AS

--DECLARE @Difficulty int, @GameType varchar(20)
--
--SET @Difficulty =7
--SET @GameType = ''Arms''

SELECT TOP 10
	SCAPeople.PeopleId,
	SCAPeople.HighestAwardName,
	SCAPeople.HighestAwardDate,
	SCAPeople.HighestAwardId,
	SCAPeople.SCAName,
	SCAPeople.OPNum,
	SCAPeople.ArmsUrl as ArmsFileId,
	SCAPeople.PhotoUrl as PhotoFileId,
case when photoFiles.FileName is null then SCAPeople.PhotoURL else photoFiles.Folder + photoFiles.FileName end as PhotoUrl,
	case when photoFiles.Width is null then 0 else photoFiles.Width end as PhotoUrlWidth,
	case when photoFiles.Height is null then 0 else photoFiles.Height end as PhotoUrlHeight,
	case when armsFiles.FileName is null then SCAPeople.ArmsURL else armsFiles.Folder + armsFiles.FileName end as ArmsUrl,
	case when armsFiles.Width is null then 0 else armsFiles.Width end as ArmsUrlWidth,
	case when armsFiles.Height is null then 0 else armsFiles.Height end as ArmsUrlHeight,
	SCAPeople.ArmsBlazon,
	SCAPeople.ShowPicPermission,
(SELECT MAX(Date) from dbo.SCAPeopleAward where SCAPeopleAward.PeopleId = SCAPeople.PeopleId) as MostRecentAwardDate,
(SELECT MAX(EndDate) from dbo.SCACrowns where SCACrowns.SovereignId = SCAPeople.PeopleId OR SCACrowns.ConsortId = SCAPeople.PeopleId) as MostRecentReign,
NewID() as random
FROM SCAPeople 
left join Files photoFiles on SCAPeople.PhotoURL = ''fileid='' + convert(varchar,photoFiles.FileID)
left join Files armsFiles on SCAPeople.ArmsURL = ''fileid='' + convert(varchar,armsFiles.FileID)
WHERE 
((@GameType = ''Arms'' and SCAPeople.armsurl is not null) OR
(@GameType = ''Photo'' and SCAPeople.photoUrl is not null and SCAPeople.ShowPicPermission=1)) 
AND
(
(@Difficulty = 1 AND  HighestAwardId = -1) --Current Royalty
OR 
(@Difficulty = 2 AND  (HighestAwardId = -1 OR DATEDIFF(yyyy, (SELECT MAX(EndDate) from dbo.SCACrowns where SCACrowns.SovereignId = SCAPeople.PeopleId OR SCACrowns.ConsortId = SCAPeople.PeopleId), GETDATE())<=2  )) -- Add Royalty within last 2 years
OR
(@Difficulty = 3 AND  
(HighestAwardId = -1 OR 
	DATEDIFF(yyyy, (SELECT MAX(EndDate) from dbo.SCACrowns where SCACrowns.SovereignId = SCAPeople.PeopleId OR 
	SCACrowns.ConsortId = SCAPeople.PeopleId), GETDATE())<=2 OR
	(HighestAwardPrecedence IN (100,101,102,103,104) AND  
	DATEDIFF(yyyy, (SELECT MAX(Date) from dbo.SCAPeopleAward where SCAPeopleAward.PeopleId = SCAPeople.PeopleId), GETDATE())<=2 ) )) -- Add any peers with a recent award
OR
(@Difficulty = 4 AND 
	(HighestAwardId = -1 OR 
	(HighestAwardPrecedence <=130 AND  
	DATEDIFF(yyyy, (SELECT MAX(Date) from dbo.SCAPeopleAward where SCAPeopleAward.PeopleId = SCAPeople.PeopleId), GETDATE())<=2 ))) --Award of Arms or Higher with recent activity
OR
(@Difficulty = 5 AND 
	(HighestAwardId = -1 OR 
	(DATEDIFF(yyyy, (SELECT MAX(Date) from dbo.SCAPeopleAward where SCAPeopleAward.PeopleId = SCAPeople.PeopleId), GETDATE())<=5 ))) --Anyone with activity in the last 5 years
OR
(@Difficulty = 6 AND 
	(HighestAwardId = -1 OR 
	(DATEDIFF(yyyy, (SELECT MAX(Date) from dbo.SCAPeopleAward where SCAPeopleAward.PeopleId = SCAPeople.PeopleId), GETDATE())<=10 ))) --Anyone with activity in the last 10 years
OR
(@Difficulty = 7 ) -- Everyone with Arms or Photos
)
ORDER BY newid()


' 
END
GO
/****** Object:  View {databaseOwner}.{objectQualifier}[SCAWholeEnchilada]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAWholeEnchilada]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW {databaseOwner}.{objectQualifier}[SCAWholeEnchilada]
AS
SELECT     dbo.SCAPeople.PeopleId, dbo.SCAPeople.SCAName, dbo.SCAPeople.MundaneName, dbo.SCAPeople.Address1, dbo.SCAPeople.Address2, 
                      dbo.SCAPeople.City, dbo.SCAPeople.State, dbo.SCAPeople.Zip, dbo.SCAPeople.Phone1, dbo.SCAPeople.Phone2, dbo.SCAPeople.EmailAddress, 
                      CASE WHEN photoFiles.FileName IS NULL THEN SCAPeople.PhotoURL ELSE photoFiles.Folder + photoFiles.FileName END AS PhotoURL, 
                      CASE WHEN photoFiles.Width IS NULL THEN 0 ELSE photoFiles.Width END AS PhotoURLWidth, CASE WHEN photoFiles.Height IS NULL 
                      THEN 0 ELSE photoFiles.Height END AS PhotoURLHeight, CASE WHEN armsFiles.FileName IS NULL 
                      THEN SCAPeople.ArmsURL ELSE armsFiles.Folder + armsFiles.FileName END AS ArmsURL, CASE WHEN armsFiles.Width IS NULL 
                      THEN 0 ELSE armsFiles.Width END AS ArmsURLWidth, CASE WHEN armsFiles.Height IS NULL 
                      THEN 0 ELSE armsFiles.Height END AS ArmsURLHeight, dbo.SCAPeople.ArmsBlazon, dbo.SCAPeople.ShowPicPermission, 
                      dbo.SCAPeople.ShowEmailPermission, dbo.SCAPeople.AdminNotes, dbo.SCAPeople.OfficerNotes, dbo.SCAPeople.OPNum, dbo.SCAPeople.Gender, 
                      dbo.SCAPeople.TitlePrefix, dbo.SCAPeople.HonorsSuffix, dbo.SCAPeopleAward.Date, dbo.SCAPeopleAward.CrownId, dbo.SCAPeopleAward.Notes, 
                      dbo.SCAPeopleAward.Retired, dbo.SCAAwards.Name, dbo.SCAAwards.Precedence, dbo.SCAAwards.SortOrder, 
                      dbo.SCAGroups.Name AS AwardGroup,dbo.SCAGroups.GroupId AS AwardGroupId,
						CASE SCAAwards.AwardedById 
						WHEN 1 THEN 
							CASE WHEN LEFT(S.SCAName,
							CASE WHEN PATINDEX(''% %'',S.SCAName)>0 THEN PATINDEX(''% %'',S.SCAName) -1 ELSE 0 END) = '''' THEN S.SCAName ELSE LEFT(S.SCAName,
							CASE WHEN PATINDEX(''% %'',S.SCAName)>0 THEN PATINDEX(''% %'',S.SCAName) -1 ELSE 0 END) END + '' and '' + CASE WHEN LEFT(C.SCAName,
							CASE WHEN PATINDEX(''% %'',C.SCAName)>0 THEN PATINDEX(''% %'',C.SCAName) -1 ELSE 0 END) = '''' THEN C.SCAName ELSE LEFT(C.SCAName,
							CASE WHEN PATINDEX(''% %'',C.SCAName)>0 THEN PATINDEX(''% %'',C.SCAName) -1 ELSE 0 END) END 
						WHEN 2 THEN 
							CASE WHEN LEFT(S.SCAName,
							CASE WHEN PATINDEX(''% %'',S.SCAName)>0 THEN PATINDEX(''% %'',S.SCAName) -1 ELSE 0 END) = '''' THEN S.SCAName ELSE LEFT(S.SCAName,
							CASE WHEN PATINDEX(''% %'',S.SCAName)>0 THEN PATINDEX(''% %'',S.SCAName) -1 ELSE 0 END) END 
						WHEN 3 THEN 
							CASE WHEN LEFT(C.SCAName,
							CASE WHEN PATINDEX(''% %'',C.SCAName)>0 THEN PATINDEX(''% %'',C.SCAName) -1 ELSE 0 END) = '''' THEN C.SCAName ELSE LEFT(C.SCAName,
							CASE WHEN PATINDEX(''% %'',C.SCAName)>0 THEN PATINDEX(''% %'',C.SCAName) -1 ELSE 0 END) END
							END AS AwardedBy,
							A.SCAName AS NameOnScroll
FROM         dbo.SCAPeople INNER JOIN
                      dbo.SCAPeopleAward ON dbo.SCAPeople.PeopleId = dbo.SCAPeopleAward.PeopleId 
						LEFT JOIN SCACrowns ON SCAPeopleAward.CrownId = SCACrowns.CrownId
						LEFT JOIN SCAPeople C ON SCACrowns.ConsortId = C.PeopleId
						LEFT JOIN SCAPeople S ON SCACrowns.SovereignId = S.PeopleId
						LEFT JOIN SCAAlias A ON SCAPeopleAward.AliasId = A.AliasId
						INNER JOIN dbo.SCAAwards ON dbo.SCAPeopleAward.AwardId = dbo.SCAAwards.AwardId LEFT OUTER JOIN
                      dbo.SCAGroups ON dbo.SCAAwards.GroupId = dbo.SCAGroups.GroupId LEFT OUTER JOIN
                      dbo.Files photoFiles ON dbo.SCAPeople.PhotoURL = ''fileid='' + CONVERT(varchar, photoFiles.FileId) LEFT OUTER JOIN
                      dbo.Files armsFiles ON dbo.SCAPeople.ArmsURL = ''fileid='' + CONVERT(varchar, armsFiles.FileId)
'
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAUpdatePeopleOPNum]    Script Date: 06/02/2010 22:32:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAUpdatePeopleOPNum]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- Stored Procedure

CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAUpdatePeopleOPNum] AS 

--Sovereign of Atenveldt
SELECT
	SCAPeople.[PeopleId],
	CASE GENDER WHEN ''M'' THEN ''King'' WHEN ''F'' then ''Queen'' ELSE ''Sovereign'' END as HighestAwardName,
	SCAPeople.[SCAName],
	SCAPeople.[MundaneName],
	SCAPeople.[Address1],
	SCAPeople.[Address2],
	SCAPeople.[City],
	SCAPeople.[State],
	SCAPeople.[Zip],
	SCAPeople.[Phone1],
	SCAPeople.[Phone2],
	SCAPeople.[EmailAddress],
	SCAPeople.[PhotoURL],
	SCAPeople.[ArmsURL],
	SCAPeople.[ArmsBlazon],
	SCAPeople.[ShowPicPermission],
	SCAPeople.[ShowEmailPermission],
	SCAPeople.[AdminNotes],
	SCAPeople.[OfficerNotes],
	1 as HighestAwardPrecedence,
	SCACrowns.StartDate as HighestAwardDate
FROM SCAPeople
JOIN SCACrowns on SCAPeople.PeopleId = SovereignId
WHERE Reign =(
Select
	Max(reign)
from SCACrowns
where GroupId = 26)
	and GroupId = 26
UNION --Consort of Atenveldt
SELECT
	SCAPeople.[PeopleId],
	CASE GENDER WHEN ''M'' THEN ''Consort'' WHEN ''F'' then ''Queen'' ELSE ''Consort'' END as HighestAwardName,
	SCAPeople.[SCAName],
	SCAPeople.[MundaneName],
	SCAPeople.[Address1],
	SCAPeople.[Address2],
	SCAPeople.[City],
	SCAPeople.[State],
	SCAPeople.[Zip],
	SCAPeople.[Phone1],
	SCAPeople.[Phone2],
	SCAPeople.[EmailAddress],
	SCAPeople.[PhotoURL],
	SCAPeople.[ArmsURL],
	SCAPeople.[ArmsBlazon],
	SCAPeople.[ShowPicPermission],
	SCAPeople.[ShowEmailPermission],
	SCAPeople.[AdminNotes],
	SCAPeople.[OfficerNotes],
	2 as HighestAwardPrecedence,
	SCACrowns.StartDate as HighestAwardDate
FROM SCAPeople
JOIN SCACrowns on SCAPeople.PeopleId = ConsortId
WHERE Reign =(
Select
	Max(reign)
from SCACrowns
where GroupId = 26)
	and GroupId = 26
UNION --Crowned Prince/Princess of Atenveldt
SELECT
	SCAPeople.[PeopleId],
	CASE GENDER WHEN ''M'' THEN ''Crown Prince'' WHEN ''F'' then ''Crown Princess'' ELSE ''Heir'' END as HighestAwardName,
	SCAPeople.[SCAName],
	SCAPeople.[MundaneName],
	SCAPeople.[Address1],
	SCAPeople.[Address2],
	SCAPeople.[City],
	SCAPeople.[State],
	SCAPeople.[Zip],
	SCAPeople.[Phone1],
	SCAPeople.[Phone2],
	SCAPeople.[EmailAddress],
	SCAPeople.[PhotoURL],
	SCAPeople.[ArmsURL],
	SCAPeople.[ArmsBlazon],
	SCAPeople.[ShowPicPermission],
	SCAPeople.[ShowEmailPermission],
	SCAPeople.[AdminNotes],
	SCAPeople.[OfficerNotes],
	3 as HighestAwardPrecedence,
	SCACrowns.StartDate as HighestAwardDate
FROM SCAPeople
JOIN SCACrowns on SCAPeople.PeopleId = SovereignId
WHERE Reign =(
Select
	Max(reign)
from SCACrowns
where GroupId = 49)
	and GroupId = 49
UNION --Crowned Prince/Princess of Atenveldt
SELECT
	SCAPeople.[PeopleId],
	CASE GENDER WHEN ''M'' THEN ''Crown Princess Consort'' WHEN ''F'' then ''Crown Princess'' ELSE ''Heir'' END as HighestAwardName,
	SCAPeople.[SCAName],
	SCAPeople.[MundaneName],
	SCAPeople.[Address1],
	SCAPeople.[Address2],
	SCAPeople.[City],
	SCAPeople.[State],
	SCAPeople.[Zip],
	SCAPeople.[Phone1],
	SCAPeople.[Phone2],
	SCAPeople.[EmailAddress],
	SCAPeople.[PhotoURL],
	SCAPeople.[ArmsURL],
	SCAPeople.[ArmsBlazon],
	SCAPeople.[ShowPicPermission],
	SCAPeople.[ShowEmailPermission],
	SCAPeople.[AdminNotes],
	SCAPeople.[OfficerNotes],
	4 as HighestAwardPrecedence,
	SCACrowns.StartDate as HighestAwardDate
FROM SCAPeople
JOIN SCACrowns on SCAPeople.PeopleId = ConsortId
WHERE Reign =(
Select
	Max(reign)
from SCACrowns
where GroupId = 49)
	and GroupId = 49
UNION -- Baronies
SELECT
	SCAPeople.[PeopleId],
	CASE GENDER WHEN ''M'' THEN ''Baron of '' + SCAGroups.Name WHEN ''F'' then ''Baroness of '' + SCAGroups.Name ELSE ''Coronet of '' + SCAGroups.Name END as HighestAwardName,
	SCAPeople.[SCAName],
	SCAPeople.[MundaneName],
	SCAPeople.[Address1],
	SCAPeople.[Address2],
	SCAPeople.[City],
	SCAPeople.[State],
	SCAPeople.[Zip],
	SCAPeople.[Phone1],
	SCAPeople.[Phone2],
	SCAPeople.[EmailAddress],
	SCAPeople.[PhotoURL],
	SCAPeople.[ArmsURL],
	SCAPeople.[ArmsBlazon],
	SCAPeople.[ShowPicPermission],
	SCAPeople.[ShowEmailPermission],
	SCAPeople.[AdminNotes],
	SCAPeople.[OfficerNotes],
	(SCAGroups.Precedence*2 - 200 + 8)+ + CASE WHEN SCAPeople.PeopleId=SCACrowns.SovereignID THEN 0 ELSE 1 END as HighestAwardPrecedence,
	SCACrowns.StartDate as HighestAwardDate
FROM SCAPeople
JOIN SCACrowns on SCAPeople.PeopleId = SovereignID OR SCAPeople.PeopleId = ConsortId
JOIN SCAGROUps on SCACrowns.GroupId = SCAGROUps.groupid
WHERE SCACROWNS.groupid in(44,45,46,47,48)
	and SCACrowns.CrownId = (Select
				crownid
			from scacrowns wcrn
			where wcrn.groupid = SCACrowns.groupid
				and wcrn.reign = (Select
						max(reign)
						from scacrowns w2crn
						where w2crn.groupid =SCACrowns.groupid ) )
UNION
SELECT
	DISTINCT SCAPeople.[PeopleId],
	SCAAwards.Name as HighestAwardName,
	SCAPeople.[SCAName],
	SCAPeople.[MundaneName],
	SCAPeople.[Address1],
	SCAPeople.[Address2],
	SCAPeople.[City],
	SCAPeople.[State],
	SCAPeople.[Zip],
	SCAPeople.[Phone1],
	SCAPeople.[Phone2],
	SCAPeople.[EmailAddress],
	SCAPeople.[PhotoURL],
	SCAPeople.[ArmsURL],
	SCAPeople.[ArmsBlazon],
	SCAPeople.[ShowPicPermission],
	SCAPeople.[ShowEmailPermission],
	SCAPeople.[AdminNotes],
	SCAPeople.[OfficerNotes],
	CASE WHEN SCAAwards.Precedence IS NULL THEN 1000 ELSE SCAAwards.Precedence END as HighestAwardPrecedence,
	SCAPeopleAward.Date as HighestAwardDate
FROM SCAPeople
JOIN dbo.SCAPeopleAward ON SCAPEopleAward.PeopleId = SCAPeople.PeopleId
JOIN dbo.SCAAwards ON dbo.SCAPeopleAward.AwardId = dbo.SCAAwards.AwardId
WHERE CASE WHEN SCAAwards.Precedence IS NULL THEN 1000 ELSE SCAAwards.Precedence END = 
					(Select
						MIN(CASE WHEN Precedence IS NULL THEN 1000 ELSE Precedence END)
						from SCAAwards wA
						JOIN SCAPeopleAward wPA on wPA.Awardid = wA.AwardId
						WHERE wpa.PeopleId = SCAPeople.PeopleId
						AND wpa.Retired =0
						Group By wpa.Peopleid )
	AND SCAPeopleAward.Date = 	(Select
						MIN(Date)
						from SCAAwards w2A
						JOIN SCAPeopleAward w2PA on w2PA.Awardid = w2A.AwardId
						WHERE w2pa.PeopleId = SCAPeople.PeopleId
						AND CASE WHEN w2a.precedence IS NULL THEN 1000 ELSE w2a.precedence END = 
						(Select
							MIN(CASE WHEN Precedence IS NULL THEN 1000 ELSE Precedence END)
							from SCAAwards wA
							JOIN SCAPeopleAward wPA on wPA.Awardid = wA.AwardId
							WHERE wpa.PeopleId = SCAPeople.PeopleId
								AND wpa.Retired =0
							Group By wpa.Peopleid )
						Group By w2pa.Peopleid )
	AND SCAPeople.PeopleId NOT IN ( 
--Crown of Atenveldt
		SELECT
			SCAPeople.[PeopleId]
		FROM SCAPeople
		JOIN SCACrowns on SCAPeople.PeopleId = SovereignId
		WHERE Reign =(
		Select
			Max(reign)
		from SCACrowns
		where GroupId = 26)
			and GroupId = 26
		UNION 
--Consort of Atenveldt
		SELECT
			SCAPeople.[PeopleId]
		FROM SCAPeople
		JOIN SCACrowns on SCAPeople.PeopleId = ConsortId
		WHERE Reign =(
		Select
			Max(reign)
		from SCACrowns
		where GroupId = 26)
			and GroupId = 26
		UNION 
--Crowned Prince/Princess of Atenveldt
		SELECT
			SCAPeople.[PeopleId]
		FROM SCAPeople
		JOIN SCACrowns on SCAPeople.PeopleId = SovereignId
		WHERE Reign =(
		Select
			Max(reign)
		from SCACrowns
		where GroupId = 49)
			and GroupId = 49
		UNION 
--Crowned Prince/Princess of Atenveldt
		SELECT
			SCAPeople.[PeopleId]
		FROM SCAPeople
		JOIN SCACrowns on SCAPeople.PeopleId = ConsortId
		WHERE Reign =(
		Select
			Max(reign)
		from SCACrowns
		where GroupId = 49)
			and GroupId = 49
		UNION 
		-- Baronies
		SELECT
			SCAPeople.[PeopleId]
		FROM SCAPeople
		JOIN SCACrowns on SCAPeople.PeopleId = SovereignID OR SCAPeople.PeopleId = ConsortId
		JOIN SCAGROUps on SCACrowns.GroupId = SCAGROUps.groupid
		WHERE SCACROWNS.groupid in(44,45,46,47,48)
			and SCACrowns.CrownId = (Select
			crownid
		from scacrowns wcrn
		where wcrn.groupid = SCACrowns.groupid
			and wcrn.reign = 
			(Select
				max(reign)
				from scacrowns w2crn
				where w2crn.groupid =SCACrowns.groupid ) 
	) )
Order By HighestAwardPrecedence ASC,
	HighestAwardDate ASC 

' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleWholeEnchiladaReport]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleWholeEnchiladaReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Jeff Martin
-- Create date: 9/17/2006
-- Description:	retrieves data for full report
-- =============================================
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleWholeEnchiladaReport] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	SELECT 
		SCAName, 
		MundaneName, 
		Address1, 
		Address2, 
		City, 
		State, 
		Zip, 
		Phone1, 
		Phone2, 
		EmailAddress, 
		PhotoURL, 
		PhotoURLWidth, 
		PhotoURLHeight, 
		ArmsURL, 
		ArmsURLWidth, 
		ArmsURLHeight, 
		ArmsBlazon, 
		ShowPicPermission, 
		ShowEmailPermission, 
		AdminNotes, 
		OfficerNotes, 
		OPNum, 
		Gender, 
        TitlePrefix, 
		HonorsSuffix, 
		Date, 
		CrownId, 
		Notes, 
		Retired, 
		Name as AwardName, 
		CASE WHEN SCAWholeEnchilada.Precedence IS NULL THEN 1000 ELSE SCAWholeEnchilada.Precedence END As Precedence, 
		SortOrder, 
		AwardGroup, 
		AwardedBy,
		PeopleId,
		NameOnScroll
FROM         SCAWholeEnchilada
order by OPNum
END




' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleUpdatePrecedence]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleUpdatePrecedence]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleUpdatePrecedence]
	
AS
UPDATE SCAPeople
SET OPNum = NULL

SELECT      IDENTITY (int, 1, 1) AS Rank, PeopleId,  HighestAwardName,HighestAwardPrecedence, HighestAwardDate, HighestAwardId, SCAPeopleAwardPrecedence.CrownId
INTO            [#tmpSCAOPOrder]
FROM         SCAPeopleAwardPrecedence
WHERE HighestAwardPrecedence<1000
ORDER BY HighestAwardPrecedence, HighestAwardDate

UPDATE SCAPeople
SET OPNum = Rank, 
SCAPeople.HighestAwardName = [#tmpSCAOPOrder].HighestAwardName ,
SCAPeople.HighestAwardPrecedence = [#tmpSCAOPOrder].HighestAwardPrecedence, 
SCAPeople.HighestAwardDate = [#tmpSCAOPOrder].HighestAwardDate, 
SCAPeople.HighestAwardId = [#tmpSCAOPOrder].HighestAwardId, 
SCAPeople.CrownId = [#tmpSCAOPOrder].CrownId

FROM [#tmpSCAOPOrder] 
WHERE [#tmpSCAOPOrder].PeopleId = SCAPeople.PeopleId

Drop table [#tmpSCAOPOrder]
' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleSingleGroupEnchiladaReport]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleSingleGroupEnchiladaReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Jeff Martin
-- Create date: 4/1/2007
-- Description:	retrieves data for full report
-- =============================================
CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleSingleGroupEnchiladaReport] 
	@GroupId int
AS
BEGIN
	SELECT 
		SCAName, 
		MundaneName, 
		Address1, 
		Address2, 
		City, 
		State, 
		Zip, 
		Phone1, 
		Phone2, 
		EmailAddress, 
		PhotoURL, 
		PhotoURLWidth, 
		PhotoURLHeight, 
		ArmsURL, 
		ArmsURLWidth, 
		ArmsURLHeight, 
		ArmsBlazon, 
		ShowPicPermission, 
		ShowEmailPermission, 
		AdminNotes, 
		OfficerNotes, 
		OPNum, 
		Gender, 
        TitlePrefix, 
		HonorsSuffix, 
		Date, 
		CrownId, 
		Notes, 
		Retired, 
		Name as AwardName, 
		CASE WHEN SCAWholeEnchilada.Precedence IS NULL THEN 1000 ELSE SCAWholeEnchilada.Precedence END As Precedence, 
		SortOrder, 
		AwardGroup, 
		AwardGroupId, 
		AwardedBy,
		PeopleId,
		NameOnScroll
FROM         SCAWholeEnchilada
WHERE PeopleID in (Select PeopleId from SCAPeopleAward join SCAAwards on SCAPeopleAward.AwardId = SCAAwards.AwardId where  SCAAwards.GroupId = @GroupId)
order by OPNum
END






' 
END
GO
/****** Object:  StoredProcedure {databaseOwner}.{objectQualifier}[SCAPeopleListOP]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleListOP]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE {databaseOwner}.{objectQualifier}[SCAPeopleListOP] AS
WITH ParentKingdom(GroupId,  ParentKingdom)
AS 
(
SELECT
	SCAGroups.GroupId,
	SCAGroups.GroupId
FROM SCAGroups
where ParentGroupId is null
UNION ALL 
SELECT 
SCAGroups.GroupId,
   ParentKingdom
FROM SCAGroups
JOIN ParentKingdom  ON SCAGroups.ParentGroupId = ParentKingdom.GroupId
)
SELECT 
	SCAPeople.PeopleId,
	SCAPeopleAwardPrecedence.HighestAwardName,
	SCAPeopleAwardPrecedence.HighestAwardDate,
	SCAPeopleAwardPrecedence.HighestAwardId,
	SCAPeople.SCAName,
	SCAPeople.OPNum,
	SCAPeople.ArmsUrl,
	SCAPeople.PhotoURL,
	SCAPeople.ShowPicPermission,
	SCAPeopleAwardPrecedence.CrownId,
	SCAPeople.MundaneName,
	Deceased,
	[DeceasedWhen],
	[BranchResidenceId],
	branchresidence.Name as BranchResidence,
	ParentKingdom
FROM SCAPeople 
JOIN SCAPeopleAwardPrecedence ON SCAPeople.PeopleId = SCAPeopleAwardPrecedence.PeopleId
left join scagroups branchresidence on SCAPeople.BranchResidenceId = branchresidence.GroupId
left join ParentKingdom on ParentKingdom.GroupId = BranchResidenceId
ORDER BY SCAPeople.OPNum





' 
END
GO
/****** Object:  View {databaseOwner}.{objectQualifier}[SCAOPList]    Script Date: 06/02/2010 22:32:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAOPList]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW {databaseOwner}.{objectQualifier}[SCAOPList]
AS
SELECT     dbo.SCAPeople.PeopleId, dbo.SCAPeopleAwardPrecedence.HighestAwardName, dbo.SCAPeopleAwardPrecedence.HighestAwardDate, 
                      dbo.SCAPeopleAwardPrecedence.HighestAwardId, dbo.SCAPeople.SCAName, dbo.SCAPeople.OPNum, dbo.SCAPeople.ArmsURL
FROM         dbo.SCAPeople INNER JOIN
                      dbo.SCAPeopleAwardPrecedence ON dbo.SCAPeople.PeopleId = dbo.SCAPeopleAwardPrecedence.PeopleId

'
GO
/****** Object:  Default [DF_SCAAwards_Honorary]    Script Date: 06/02/2010 22:32:02 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[DF_SCAAwards_Honorary]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAwards]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_SCAAwards_Honorary]') AND type = 'D')
BEGIN
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAAwards] ADD  CONSTRAINT [DF_SCAAwards_Honorary]  DEFAULT ((0)) FOR [Honorary]
END


End
GO
/****** Object:  Default [DF_SCACrowns_Heir]    Script Date: 06/02/2010 22:32:02 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[DF_SCACrowns_Heir]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCACrowns]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_SCACrowns_Heir]') AND type = 'D')
BEGIN
ALTER TABLE {databaseOwner}.{objectQualifier}[SCACrowns] ADD  CONSTRAINT [DF_SCACrowns_Heir]  DEFAULT ((0)) FOR [Heir]
END


End
GO
/****** Object:  Default [DF_SCACrowns_Regent]    Script Date: 06/02/2010 22:32:02 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[DF_SCACrowns_Regent]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCACrowns]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_SCACrowns_Regent]') AND type = 'D')
BEGIN
ALTER TABLE {databaseOwner}.{objectQualifier}[SCACrowns] ADD  CONSTRAINT [DF_SCACrowns_Regent]  DEFAULT ((0)) FOR [Regent]
END


End
GO
/****** Object:  Default [DF_SCAOfficerPosition_LinkedToCrown]    Script Date: 06/02/2010 22:32:02 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[DF_SCAOfficerPosition_LinkedToCrown]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAOfficerPosition]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_SCAOfficerPosition_LinkedToCrown]') AND type = 'D')
BEGIN
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAOfficerPosition] ADD  CONSTRAINT [DF_SCAOfficerPosition_LinkedToCrown]  DEFAULT ((0)) FOR [LinkedToCrown]
END


End
GO
/****** Object:  Default [DF_SCAPeople_ShowPicPermission]    Script Date: 06/02/2010 22:32:02 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[DF_SCAPeople_ShowPicPermission]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeople]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_SCAPeople_ShowPicPermission]') AND type = 'D')
BEGIN
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAPeople] ADD  CONSTRAINT [DF_SCAPeople_ShowPicPermission]  DEFAULT ((0)) FOR [ShowPicPermission]
END


End
GO
/****** Object:  Default [DF_SCAPeople_ShowEmailPermission]    Script Date: 06/02/2010 22:32:02 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[DF_SCAPeople_ShowEmailPermission]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeople]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_SCAPeople_ShowEmailPermission]') AND type = 'D')
BEGIN
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAPeople] ADD  CONSTRAINT [DF_SCAPeople_ShowEmailPermission]  DEFAULT ((0)) FOR [ShowEmailPermission]
END


End
GO
/****** Object:  Default [DF_SCAPeople_Deceased]    Script Date: 06/02/2010 22:32:02 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[DF_SCAPeople_Deceased]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeople]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_SCAPeople_Deceased]') AND type = 'D')
BEGIN
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAPeople] ADD  CONSTRAINT [DF_SCAPeople_Deceased]  DEFAULT ((0)) FOR [Deceased]
END


End
GO
/****** Object:  Default [DF_SCAPeopleAward_Retired]    Script Date: 06/02/2010 22:32:02 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[DF_SCAPeopleAward_Retired]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleAward]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_SCAPeopleAward_Retired]') AND type = 'D')
BEGIN
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAPeopleAward] ADD  CONSTRAINT [DF_SCAPeopleAward_Retired]  DEFAULT ((0)) FOR [Retired]
END


End
GO
/****** Object:  Default [DF_SCAPeopleOfficer_Acting]    Script Date: 06/02/2010 22:32:02 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[DF_SCAPeopleOfficer_Acting]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleOfficer]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_SCAPeopleOfficer_Acting]') AND type = 'D')
BEGIN
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAPeopleOfficer] ADD  CONSTRAINT [DF_SCAPeopleOfficer_Acting]  DEFAULT ((0)) FOR [Acting]
END


End
GO
/****** Object:  Default [DF_SCAPeopleOfficer_Verfied]    Script Date: 06/02/2010 22:32:02 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[DF_SCAPeopleOfficer_Verfied]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleOfficer]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_SCAPeopleOfficer_Verfied]') AND type = 'D')
BEGIN
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAPeopleOfficer] ADD  CONSTRAINT [DF_SCAPeopleOfficer_Verfied]  DEFAULT ((1)) FOR [Verified]
END


End
GO
/****** Object:  Default [DF_SCAPeopleOfficer_EmailToUse]    Script Date: 06/02/2010 22:32:02 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[DF_SCAPeopleOfficer_EmailToUse]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleOfficer]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_SCAPeopleOfficer_EmailToUse]') AND type = 'D')
BEGIN
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAPeopleOfficer] ADD  CONSTRAINT [DF_SCAPeopleOfficer_EmailToUse]  DEFAULT ('Personal') FOR [EmailToUse]
END


End
GO

/****** Object:  ForeignKey [FK_SCAAlias_SCAPeople]    Script Date: 06/02/2010 22:32:02 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAAlias_SCAPeople]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAlias]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAAlias]  WITH CHECK ADD  CONSTRAINT [FK_SCAAlias_SCAPeople] FOREIGN KEY([PeopleId])
REFERENCES {databaseOwner}.{objectQualifier}[SCAPeople] ([PeopleId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAAlias_SCAPeople]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAlias]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAAlias] CHECK CONSTRAINT [FK_SCAAlias_SCAPeople]
GO
/****** Object:  ForeignKey [FK_SCAAwardGroups_SCAGroups]    Script Date: 06/02/2010 22:32:02 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAAwardGroups_SCAGroups]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAwardGroups]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAAwardGroups]  WITH NOCHECK ADD  CONSTRAINT [FK_SCAAwardGroups_SCAGroups] FOREIGN KEY([GroupId])
REFERENCES {databaseOwner}.{objectQualifier}[SCAGroups] ([GroupId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAAwardGroups_SCAGroups]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAwardGroups]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAAwardGroups] CHECK CONSTRAINT [FK_SCAAwardGroups_SCAGroups]
GO
/****** Object:  ForeignKey [FK_SCAAwards_SCAAwardedBy]    Script Date: 06/02/2010 22:32:02 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAAwards_SCAAwardedBy]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAwards]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAAwards]  WITH NOCHECK ADD  CONSTRAINT [FK_SCAAwards_SCAAwardedBy] FOREIGN KEY([AwardedById])
REFERENCES {databaseOwner}.{objectQualifier}[SCAAwardedBy] ([AwardedById])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAAwards_SCAAwardedBy]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAwards]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAAwards] CHECK CONSTRAINT [FK_SCAAwards_SCAAwardedBy]
GO
/****** Object:  ForeignKey [FK_SCAAwards_SCAAwardGroups]    Script Date: 06/02/2010 22:32:02 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAAwards_SCAAwardGroups]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAwards]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAAwards]  WITH NOCHECK ADD  CONSTRAINT [FK_SCAAwards_SCAAwardGroups] FOREIGN KEY([AwardGroupId])
REFERENCES {databaseOwner}.{objectQualifier}[SCAAwardGroups] ([AwardGroupId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAAwards_SCAAwardGroups]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAwards]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAAwards] CHECK CONSTRAINT [FK_SCAAwards_SCAAwardGroups]
GO
/****** Object:  ForeignKey [FK_SCAAwards_SCAGroups]    Script Date: 06/02/2010 22:32:02 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAAwards_SCAGroups]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAwards]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAAwards]  WITH NOCHECK ADD  CONSTRAINT [FK_SCAAwards_SCAGroups] FOREIGN KEY([GroupId])
REFERENCES {databaseOwner}.{objectQualifier}[SCAGroups] ([GroupId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAAwards_SCAGroups]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAAwards]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAAwards] CHECK CONSTRAINT [FK_SCAAwards_SCAGroups]
GO
/****** Object:  ForeignKey [FK_SCACrownLetters_SCACrowns]    Script Date: 06/02/2010 22:32:02 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCACrownLetters_SCACrowns]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCACrownLetters]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCACrownLetters]  WITH NOCHECK ADD  CONSTRAINT [FK_SCACrownLetters_SCACrowns] FOREIGN KEY([CrownId])
REFERENCES {databaseOwner}.{objectQualifier}[SCACrowns] ([CrownId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCACrownLetters_SCACrowns]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCACrownLetters]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCACrownLetters] CHECK CONSTRAINT [FK_SCACrownLetters_SCACrowns]
GO
/****** Object:  ForeignKey [FK_SCACrowns_SCAGroups]    Script Date: 06/02/2010 22:32:02 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCACrowns_SCAGroups]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCACrowns]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCACrowns]  WITH NOCHECK ADD  CONSTRAINT [FK_SCACrowns_SCAGroups] FOREIGN KEY([GroupId])
REFERENCES {databaseOwner}.{objectQualifier}[SCAGroups] ([GroupId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCACrowns_SCAGroups]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCACrowns]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCACrowns] CHECK CONSTRAINT [FK_SCACrowns_SCAGroups]
GO
/****** Object:  ForeignKey [FK_SCAGroupHistory_SCAGroups]    Script Date: 06/02/2010 22:32:02 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAGroupHistory_SCAGroups]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroupHistory]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAGroupHistory]  WITH NOCHECK ADD  CONSTRAINT [FK_SCAGroupHistory_SCAGroups] FOREIGN KEY([FromGroupId])
REFERENCES {databaseOwner}.{objectQualifier}[SCAGroups] ([GroupId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAGroupHistory_SCAGroups]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroupHistory]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAGroupHistory] CHECK CONSTRAINT [FK_SCAGroupHistory_SCAGroups]
GO
/****** Object:  ForeignKey [FK_SCAGroupHistory_SCAGroups1]    Script Date: 06/02/2010 22:32:02 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAGroupHistory_SCAGroups1]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroupHistory]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAGroupHistory]  WITH NOCHECK ADD  CONSTRAINT [FK_SCAGroupHistory_SCAGroups1] FOREIGN KEY([ToGroupId])
REFERENCES {databaseOwner}.{objectQualifier}[SCAGroups] ([GroupId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAGroupHistory_SCAGroups1]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroupHistory]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAGroupHistory] CHECK CONSTRAINT [FK_SCAGroupHistory_SCAGroups1]
GO
/****** Object:  ForeignKey [FK_SCAGroups_SCABranchStatusId]    Script Date: 06/02/2010 22:32:02 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAGroups_SCABranchStatusId]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroups]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAGroups]  WITH NOCHECK ADD  CONSTRAINT [FK_SCAGroups_SCABranchStatusId] FOREIGN KEY([BranchStatusId])
REFERENCES {databaseOwner}.{objectQualifier}[SCABranchStatus] ([BranchStatusId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAGroups_SCABranchStatusId]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroups]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAGroups] CHECK CONSTRAINT [FK_SCAGroups_SCABranchStatusId]
GO
/****** Object:  ForeignKey [FK_SCAGroups_SCAGroupDesignation]    Script Date: 06/02/2010 22:32:02 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAGroups_SCAGroupDesignation]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroups]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAGroups]  WITH CHECK ADD  CONSTRAINT [FK_SCAGroups_SCAGroupDesignation] FOREIGN KEY([GroupDesignationId])
REFERENCES {databaseOwner}.{objectQualifier}[SCAGroupDesignation] ([GroupDesignationId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAGroups_SCAGroupDesignation]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroups]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAGroups] CHECK CONSTRAINT [FK_SCAGroups_SCAGroupDesignation]
GO
/****** Object:  ForeignKey [FK_SCAGroups_SCAGroups]    Script Date: 06/02/2010 22:32:02 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAGroups_SCAGroups]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroups]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAGroups]  WITH NOCHECK ADD  CONSTRAINT [FK_SCAGroups_SCAGroups] FOREIGN KEY([ParentGroupId])
REFERENCES {databaseOwner}.{objectQualifier}[SCAGroups] ([GroupId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAGroups_SCAGroups]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroups]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAGroups] CHECK CONSTRAINT [FK_SCAGroups_SCAGroups]
GO
/****** Object:  ForeignKey [FK_SCAGroupZipCodes_SCAGroups]    Script Date: 06/02/2010 22:32:02 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAGroupZipCodes_SCAGroups]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroupZipCodes]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAGroupZipCodes]  WITH NOCHECK ADD  CONSTRAINT [FK_SCAGroupZipCodes_SCAGroups] FOREIGN KEY([GroupId])
REFERENCES {databaseOwner}.{objectQualifier}[SCAGroups] ([GroupId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAGroupZipCodes_SCAGroups]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAGroupZipCodes]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAGroupZipCodes] CHECK CONSTRAINT [FK_SCAGroupZipCodes_SCAGroups]
GO
/****** Object:  ForeignKey [FK_SCAOfficerPosition_SCAGroups]    Script Date: 06/02/2010 22:32:02 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAOfficerPosition_SCAGroups]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAOfficerPosition]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAOfficerPosition]  WITH NOCHECK ADD  CONSTRAINT [FK_SCAOfficerPosition_SCAGroups] FOREIGN KEY([GroupId])
REFERENCES {databaseOwner}.{objectQualifier}[SCAGroups] ([GroupId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAOfficerPosition_SCAGroups]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAOfficerPosition]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAOfficerPosition] CHECK CONSTRAINT [FK_SCAOfficerPosition_SCAGroups]
GO
/****** Object:  ForeignKey [FK_SCAPeople_SCAGroups]    Script Date: 06/02/2010 22:32:02 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAPeople_SCAGroups]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeople]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAPeople]  WITH CHECK ADD  CONSTRAINT [FK_SCAPeople_SCAGroups] FOREIGN KEY([BranchResidenceId])
REFERENCES {databaseOwner}.{objectQualifier}[SCAGroups] ([GroupId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAPeople_SCAGroups]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeople]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAPeople] CHECK CONSTRAINT [FK_SCAPeople_SCAGroups]
GO
/****** Object:  ForeignKey [FK_SCAPeopleAward_SCAAlias]    Script Date: 06/02/2010 22:32:02 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAPeopleAward_SCAAlias]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleAward]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAPeopleAward]  WITH NOCHECK ADD  CONSTRAINT [FK_SCAPeopleAward_SCAAlias] FOREIGN KEY([AliasId])
REFERENCES {databaseOwner}.{objectQualifier}[SCAAlias] ([AliasId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAPeopleAward_SCAAlias]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleAward]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAPeopleAward] CHECK CONSTRAINT [FK_SCAPeopleAward_SCAAlias]
GO
/****** Object:  ForeignKey [FK_SCAPeopleAward_SCAAwards]    Script Date: 06/02/2010 22:32:02 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAPeopleAward_SCAAwards]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleAward]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAPeopleAward]  WITH NOCHECK ADD  CONSTRAINT [FK_SCAPeopleAward_SCAAwards] FOREIGN KEY([AwardId])
REFERENCES {databaseOwner}.{objectQualifier}[SCAAwards] ([AwardId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAPeopleAward_SCAAwards]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleAward]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAPeopleAward] CHECK CONSTRAINT [FK_SCAPeopleAward_SCAAwards]
GO
/****** Object:  ForeignKey [FK_SCAPeopleAward_SCACrowns]    Script Date: 06/02/2010 22:32:02 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAPeopleAward_SCACrowns]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleAward]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAPeopleAward]  WITH NOCHECK ADD  CONSTRAINT [FK_SCAPeopleAward_SCACrowns] FOREIGN KEY([CrownId])
REFERENCES {databaseOwner}.{objectQualifier}[SCACrowns] ([CrownId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAPeopleAward_SCACrowns]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleAward]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAPeopleAward] CHECK CONSTRAINT [FK_SCAPeopleAward_SCACrowns]
GO
/****** Object:  ForeignKey [FK_SCAPeopleAward_SCAPeople]    Script Date: 06/02/2010 22:32:02 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAPeopleAward_SCAPeople]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleAward]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAPeopleAward]  WITH NOCHECK ADD  CONSTRAINT [FK_SCAPeopleAward_SCAPeople] FOREIGN KEY([PeopleId])
REFERENCES {databaseOwner}.{objectQualifier}[SCAPeople] ([PeopleId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAPeopleAward_SCAPeople]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleAward]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAPeopleAward] CHECK CONSTRAINT [FK_SCAPeopleAward_SCAPeople]
GO
/****** Object:  ForeignKey [FK_SCAPeopleOfficer_SCACrowns]    Script Date: 06/02/2010 22:32:02 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAPeopleOfficer_SCACrowns]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleOfficer]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAPeopleOfficer]  WITH CHECK ADD  CONSTRAINT [FK_SCAPeopleOfficer_SCACrowns] FOREIGN KEY([LinkedCrownId])
REFERENCES {databaseOwner}.{objectQualifier}[SCACrowns] ([CrownId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAPeopleOfficer_SCACrowns]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleOfficer]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAPeopleOfficer] CHECK CONSTRAINT [FK_SCAPeopleOfficer_SCACrowns]
GO
/****** Object:  ForeignKey [FK_SCAPeopleOfficer_SCAOfficerPosition]    Script Date: 06/02/2010 22:32:02 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAPeopleOfficer_SCAOfficerPosition]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleOfficer]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAPeopleOfficer]  WITH CHECK ADD  CONSTRAINT [FK_SCAPeopleOfficer_SCAOfficerPosition] FOREIGN KEY([OfficerPositionId])
REFERENCES {databaseOwner}.{objectQualifier}[SCAOfficerPosition] ([OfficerPositionId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAPeopleOfficer_SCAOfficerPosition]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleOfficer]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAPeopleOfficer] CHECK CONSTRAINT [FK_SCAPeopleOfficer_SCAOfficerPosition]
GO
/****** Object:  ForeignKey [FK_SCAPeopleOfficer_SCAPeople]    Script Date: 06/02/2010 22:32:02 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAPeopleOfficer_SCAPeople]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleOfficer]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAPeopleOfficer]  WITH CHECK ADD  CONSTRAINT [FK_SCAPeopleOfficer_SCAPeople] FOREIGN KEY([PeopleId])
REFERENCES {databaseOwner}.{objectQualifier}[SCAPeople] ([PeopleId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[FK_SCAPeopleOfficer_SCAPeople]') AND parent_object_id = OBJECT_ID(N'{databaseOwner}.{objectQualifier}[SCAPeopleOfficer]'))
ALTER TABLE {databaseOwner}.{objectQualifier}[SCAPeopleOfficer] CHECK CONSTRAINT [FK_SCAPeopleOfficer_SCAPeople]
GO
