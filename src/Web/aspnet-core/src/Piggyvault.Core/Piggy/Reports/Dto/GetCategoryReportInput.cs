using System;

namespace Piggyvault.Piggy.Reports.Dto
{
    public class GetCategoryReportInput
    {
        public DateTime EndDate { get; set; }
        public DateTime StartDate { get; set; }
        public long UserId { get; set; }
    }
}