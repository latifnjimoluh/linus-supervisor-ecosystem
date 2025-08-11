import Link from "next/link"
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card"

export default function HelpPage() {
  return (
    <div className="space-y-6">
      <h1 className="text-3xl font-bold">Aide</h1>
      <Card className="rounded-2xl">
        <CardHeader>
          <CardTitle>Ressources</CardTitle>
        </CardHeader>
        <CardContent>
          <ul className="list-disc pl-5 space-y-2">
            <li>
              <Link href="/faq" className="text-primary underline-offset-2 hover:underline">
                FAQ
              </Link>
            </li>
            <li>
              <Link href="/guide" className="text-primary underline-offset-2 hover:underline">
                Mode d'emploi
              </Link>
            </li>
          </ul>
        </CardContent>
      </Card>
    </div>
  )
}
