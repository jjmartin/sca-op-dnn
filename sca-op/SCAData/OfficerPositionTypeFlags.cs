using System;
namespace JeffMartin.ScaData
{
    [Flags]
    public enum OfficerPositionTypeFlags
    {
        None = 0,
        UsesDisplayDates = 1 << 0,
        RelatedToReign = 1 << 1,
        Warranted = 1 << 2
    }
}