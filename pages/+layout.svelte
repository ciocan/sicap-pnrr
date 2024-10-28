<script>
import "@evidence-dev/tailwind/fonts.css";
import "../app.css";
import { EvidenceDefaultLayout } from "@evidence-dev/core-components";
export let data;
</script>

<svelte:head>
	<script defer data-domain="pnrr.sicap.ai" src="https://plausible.sicap.app/js/script.js"></script>
</svelte:head>

<EvidenceDefaultLayout 
	{data} title="SICAP PNRR" 
	githubRepo="https://github.com/ciocan/sicap-pnrr"
	maxWidth=1800
	fullWidth=true
>
	<slot slot="content" />
</EvidenceDefaultLayout>
