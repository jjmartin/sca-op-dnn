
namespace JeffMartin.ScaData
{
    public partial class OfficerPositionType
    {
        public OfficerPositionTypeFlags TypeFlags
        {
            get
            {
                return (OfficerPositionTypeFlags)intTypeFlags;
            }
            set
            {
                intTypeFlags = (int)value;
            }
        }
    }
}