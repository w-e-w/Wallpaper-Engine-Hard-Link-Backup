//  original source
//  https://superuser.com/questions/881547/how-to-determine-if-two-directory-pathnames-resolve-to-the-same-target
//  with modification and additions

    [StructLayout(LayoutKind.Sequential)]
    public struct BY_HANDLE_FILE_INFORMATION
    {
        public uint FileAttributes;
        public System.Runtime.InteropServices.ComTypes.FILETIME CreationTime;
        public System.Runtime.InteropServices.ComTypes.FILETIME LastAccessTime;
        public System.Runtime.InteropServices.ComTypes.FILETIME LastWriteTime;
        public uint VolumeSerialNumber;
        public uint FileSizeHigh;
        public uint FileSizeLow;
        public uint NumberOfLinks;
        public uint FileIndexHigh;
        public uint FileIndexLow;
    }

    [DllImport("kernel32.dll", SetLastError = true)]
    private static extern bool GetFileInformationByHandle(IntPtr hFile, out BY_HANDLE_FILE_INFORMATION lpFileInformation);

    [DllImport("kernel32.dll", EntryPoint = "CreateFileW", CharSet = CharSet.Unicode, SetLastError = true)]
    public static extern SafeFileHandle CreateFile(string lpFileName, int dwDesiredAccess, int dwShareMode,
    IntPtr SecurityAttributes, int dwCreationDisposition, int dwFlagsAndAttributes, IntPtr hTemplateFile);

    private static SafeFileHandle MY_GetFileHandle(string Path)
    {
        const int FILE_ACCESS_NEITHER = 0;
        const int FILE_SHARE_READ = 1;
        const int FILE_SHARE_WRITE = 2;
        const int CREATION_DISPOSITION_OPEN_EXISTING = 3;
        const int FILE_FLAG_BACKUP_SEMANTICS = 0x02000000;
        return CreateFile(Path, FILE_ACCESS_NEITHER, (FILE_SHARE_READ | FILE_SHARE_WRITE), System.IntPtr.Zero, CREATION_DISPOSITION_OPEN_EXISTING, FILE_FLAG_BACKUP_SEMANTICS, System.IntPtr.Zero);
    }

    private static BY_HANDLE_FILE_INFORMATION? MY_GetFileInfo(SafeFileHandle directoryHandle)
    {
        BY_HANDLE_FILE_INFORMATION objectFileInfo;
        if ((directoryHandle == null) || (!GetFileInformationByHandle(directoryHandle.DangerousGetHandle(), out objectFileInfo)))
        {
            return null;
        }
        return objectFileInfo;
    }

    public static bool MY_AreParhEqual(string Path1, string Path2)
    {
        bool bRet = false;
        // NOTE: we cannot lift the call to GetFileHandle into GetFileInfo, because we _must_
        // have both file handles open simultaneously in order for the objectFileInfo comparison
        // to be guaranteed as valid.
        using (SafeFileHandle directoryHandle1 = MY_GetFileHandle(Path1), directoryHandle2 = MY_GetFileHandle(Path2))
        {
            BY_HANDLE_FILE_INFORMATION? objectFileInfo1 = MY_GetFileInfo(directoryHandle1);
            BY_HANDLE_FILE_INFORMATION? objectFileInfo2 = MY_GetFileInfo(directoryHandle2);
            bRet = objectFileInfo1 != null
                    && objectFileInfo2 != null
                    && (objectFileInfo1.Value.FileIndexHigh == objectFileInfo2.Value.FileIndexHigh)
                    && (objectFileInfo1.Value.FileIndexLow == objectFileInfo2.Value.FileIndexLow)
                    && (objectFileInfo1.Value.VolumeSerialNumber == objectFileInfo2.Value.VolumeSerialNumber);
        }
        return bRet;
    }

    // test if Path exist
    public static bool MY_Exist(string Path)
    {
        bool bRet = false;
        using (SafeFileHandle directoryHandle = MY_GetFileHandle(Path))
        {
            BY_HANDLE_FILE_INFORMATION? objectFileInfo1 = MY_GetFileInfo(directoryHandle);
            bRet = objectFileInfo1 != null;
        }
        return bRet;
    }

    public static BY_HANDLE_FILE_INFORMATION? MY_GetFileInfoFromPath(string Path)
    {
        using (SafeFileHandle directoryHandle = MY_GetFileHandle(Path))
        {
            BY_HANDLE_FILE_INFORMATION? objectFileInfo1 = MY_GetFileInfo(directoryHandle);
            return objectFileInfo1;
        }
    }
