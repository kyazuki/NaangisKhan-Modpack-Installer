import { useEffect } from "react";
import { emit } from '@tauri-apps/api/event'
import { Box, Container, CssBaseline, CircularProgress } from "@mui/material";
import "./App.css";

function App() {
    useEffect(() => {
        emit("initialized");
    }, []);

    return (
        <>
            <CssBaseline />
            <Container>
                <Box>
                    <CircularProgress />
                    <span>アップデータを初期化中...</span>
                </Box>
            </Container>
        </>
    );
}

export default App;
